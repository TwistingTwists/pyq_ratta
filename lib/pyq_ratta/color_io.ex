defmodule Helpers.ColorIO do
  @the_types [
    :number,
    :atom,
    :string,
    :boolean,
    :binary,
    :bitstring,
    :list,
    :map,
    :regex,
    :tuple,
    :function,
    :struct,
    :pid,
    :port,
    :reference,
    :date,
    :datetime,
    nil
  ]
  @green Enum.map(@the_types, fn t -> {t, :green} end)
  @red Enum.map(@the_types, fn t -> {t, :red} end)
  @yellow Enum.map(@the_types, fn t -> {t, :yellow} end)
  @blue Enum.map(@the_types, fn t -> {t, :cyan} end)
  @purple Enum.map(@the_types, fn t -> {t, IO.ANSI.color(4, 2, 5)} end)
  @orange Enum.map(@the_types, fn t -> {t, IO.ANSI.color(4, 2, 0)} end)

  @multi Enum.map(@the_types, fn t ->
           case t do
             :number -> {t, :yellow}
             :pid -> {t, :red}
             :bitstring -> {t, :cyan}
             :map -> {t, :green}
             :atom -> {t, IO.ANSI.color(4, 2, 0)}
             :date -> {t, :blue}
             :datetime -> {t, :blue}
             :list -> {t, IO.ANSI.color(1, 5, 0)}
             # :string -> {t, IO.ANSI.color(4,2,5)}
             # :binary -> {t, IO.ANSI.color(0,2,5)}
             _ -> {t, IO.ANSI.color(4, 2, 5)}
           end
         end)

  def green(data, label \\ ""), do: prnt(data, @green, label)
  def red(data, label \\ ""), do: prnt(data, @red, label)
  def yellow(data, label \\ ""), do: prnt(data, @yellow, label)
  def blue(data, label \\ ""), do: prnt(data, @blue, label)
  def orange(data, label \\ ""), do: prnt(data, @orange, label)
  def purple(data, label \\ ""), do: prnt(data, @purple, label)
  def log(data, label \\ ""), do: prnt(data, @multi, label)

  defp prnt(data, colors, label) do
    IO.inspect("========= #{label} ========", syntax_colors: colors)
    IO.inspect(data, syntax_colors: colors, pretty: true, limit: :infinity)
    data
  end
end
