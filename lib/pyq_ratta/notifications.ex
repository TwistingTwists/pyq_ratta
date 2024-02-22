defmodule PyqRatta.Notifications do
  @moduledoc """
  Subscribes to all PubSub events and keeps them in GenServer
  """
  use GenServer

  defmodule Pagination do
    defstruct page_size: 10, page_num: 1
  end

  def get_paginated(page_size \\ 10, page_num \\ 1) do
    GenServer.call(__MODULE__, {:get_all, %Pagination{page_size: page_size, page_num: page_num}})
  end

  def get() do
    GenServer.call(__MODULE__, :get)
  end

  def insert(notification) do
    GenServer.cast(__MODULE__, {:insert, notification})
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    _ = Phoenix.PubSub.subscribe(PyqRatta.PubSub, "*")

    {:ok, []}
  end

  @impl true
  def handle_call({:get_all, %Pagination{page_size: page_size, page_num: page_num}}, _from, state) do
    start_limit = (page_num - 1) * page_size
    end_limit = start_limit + page_size

    {:reply, Enum.slice(state, start_limit..end_limit), state}
  end

  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_cast({:insert, notificaition}, state) do
    handle_info(notificaition, state)
  end

  @impl true
  def handle_info(msg, state) do
    {:noreply, [msg | state]}
  end
end
