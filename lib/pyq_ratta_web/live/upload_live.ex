defmodule PyqRattaWeb.UploadLive do
  use PyqRattaWeb, :live_view

  @defaults %{
    # choose between trigger upload vs manual upload
    # trigger_upload?: true,
    notified_updates: [],
    # disabled: false,
    # time_left: nil,

    # upload_key for liveview
    # to ensure we can have a generic upload_key (instead of just @upload.video.ref, we can use @upload[upload_key][:ref])
    upload_key: :video,
    accept_upload_types: ~w( .jpg .jpeg ),
    max_entries: 100,

    # default params for upload in liveview
    # 10 MB
    max_file_size: 10 * 1000 * 1000,
    # max_file_size: 5000 * 1000 * 1000,

    # 1 MB
    chunk_size: 1 * 1024 * 1024,
    chunk_timeout: 90 * 2 * 1000,

    # live select options 
    form: %{},
    selected_cid: nil,
    all_courses: []
  }

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div class="mt-5">
      <form id="video-upload-form" phx-submit="save" phx-change="validate">
        <.upload_component {assigns} />
      </form>
      <.update_notifications {assigns} />
    </div>
    """
  end

  def upload_component(assigns) do
    ~H"""
    <div class="sm:grid sm:border-t sm:border-gray-200 sm:pt-5 ">
      <%!-- render progress bar for upload --%>
      <%= for entry <- get_by(@uploads, [@upload_key, :entries]) do %>
        <div class=" text-center text-gray-600">
          <div
            role="progressbar"
            aria-valuemin="0"
            aria-valuemax="100"
            aria-valuenow={entry.progress}
            style={"transition: width 0.5s ease-in-out; width: #{entry.progress}%; min-width: 1px;"}
            class="col-span-full bg-purple-500  h-1.5 w-0 p-0"
          >
          </div>
          <%= entry.progress %> %
          <button
            type="button"
            phx-click="cancel-upload"
            phx-value-ref={entry.ref}
            aria-label="cancel"
          >
            &times;
          </button>
        </div>

        <%= for err <- upload_errors(get_by(@uploads, [@upload_key]), entry) do %>
          <p class="alert alert-danger"><%= error_to_string(err) %></p>
        <% end %>
      <% end %>
      <%!-- upload drop zone --%>
      <div class="mt-1 sm:mt-0" phx-drop-target={get_by(@uploads, [@upload_key, :ref])}>
        <div class="max-w-lg flex justify-center px-6 pt-5 pb-6 border-2 border-gray-300 border-dashed rounded-md hover:bg-gray-100">
          <div class="space-y-1 text-center">
            <svg
              class="mx-auto h-12 w-12 text-gray-400"
              stroke="currentColor"
              fill="none"
              viewBox="0 0 48 48"
              aria-hidden="true"
            >
              <path
                d="M28 8H12a4 4 0 00-4 4v20m32-12v8m0 0v8a4 4 0 01-4 4H12a4 4 0 01-4-4v-4m32-4l-3.172-3.172a4 4 0 00-5.656 0L28 28M8 32l9.172-9.172a4 4 0 015.656 0L28 28m0 0l4 4m4-24h8m-4-4v8m-12 4h.02"
                stroke-width="2"
                stroke-linecap="round"
                stroke-linejoin="round"
              >
              </path>
            </svg>

            <div class="flex text-sm text-gray-600">
              <label
                for={get_by(@uploads, [@upload_key, :ref])}
                class="relative cursor-pointer bg-white rounded-md font-medium text-yellow-600 hover:text-indigo-500 focus-within:outline-none focus-within:ring-2 focus-within:ring-offset-2 focus-within:ring-indigo-500"
              >
                <span phx-click={js_exec("##{get_by(@uploads, [@upload_key, :ref])}", "click", [])}>
                  Upload files
                </span>
                <.live_file_input
                  upload={get_by(@uploads, [@upload_key])}
                  class=" hover:bg-blue-200 sr-only "
                  tabindex="0"
                />
              </label>
              <p class="pl-1">or drag and drop</p>
            </div>
            <p class="text-xs ">
              <span class="text-red-400 font-bold">
                <%= Enum.join(assigns[:accepted_file_types] || [], ", ") %>
              </span>
              up to <%= trunc((assigns[:max_file_size] || 1) / 1_000_000) %> MB
            </p>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def update_notifications(assigns) do
    ~H"""
    <div class="bg-blue-100">
      <p class=" py-2 my-6">Current status of video processing.</p>
      <pre> <%= inspect @notified_updates, pretty: true %> </pre>
    </div>
    """
  end

  @impl Phoenix.LiveView
  def mount(params, _session, %{assigns: assigns} = socket) do
    # if connected?(socket), do: subscribe_endpoints()

    next =
      socket
      |> assign(@defaults)
      |> allow_upload(@defaults[:upload_key],
        auto_upload: true,
        progress: &handle_progress/3,
        accept: @defaults[:accept_upload_types],
        max_entries: @defaults[:max_entries],
        max_file_size: @defaults[:max_file_size],
        chunk_size: @defaults[:chunk_size],
        chunk_timeout: @defaults[:chunk_timeout]
        # writer: &s3_writer/3
      )
      |> assign(:accepted_file_types, @defaults[:accept_upload_types])

    {
      :ok,
      next
    }
  end

  def handle_progress(upload_key, entry, %{assigns: %{upload_key: upload_key}} = socket) do
    # maybe report to remote server about complete upload?
    # broadcast!(%{
    #   message: "upload_progress",
    #   type: :ok,
    #   data: %{
    #     progress: entry.progress,
    #     ref: entry.ref,
    #     entry: entry,
    #     course_id: socket.assigns.selected_cid
    #   }
    # })

    if entry.done? do
      {:noreply, put_flash(socket, :info, "file #{entry.client_name} uploaded")}
    else
      {:noreply, socket}
    end
  end

  @impl Phoenix.LiveView
  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :video, ref)}
  end

  def handle_event("validate", params, socket) do
    {:noreply, socket}
  end

  def handle_info(
        {module, %{data: update} = event},
        %{assigns: assigns} = socket
      ) do
    # green(event, label: "received in #{__MODULE__} from #{module}")
    {:noreply, assign(socket, :notified_updates, [update | assigns.notified_updates])}
  end

  def handle_info(event, %{assigns: assigns} = socket) do
    Logger.error("Unhandled handle_info in #{__MODULE__} with event: #{inspect(event)}")
    {:noreply, socket}
  end

  def error_to_string(:too_large), do: "Too large"
  def error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
  def error_to_string(:too_many_files), do: "You have selected too many files"

  defp max_uploaded(uploads), do: length(uploads.video.entries) < uploads.video.max_entries
end
