defmodule Common.Result do
  @moduledoc """
  Handles tuple with :ok and calls function
  """

  def wrap(right, left \\ :not_found)

  #   wrap for MuonTrap
  def wrap({output, 0}, _left), do: {:ok, output}
  def wrap({output, n}, _left) when n != 0, do: {:error, output}

  def wrap(nil, left), do: {:error, left}
  def wrap(right, _left), do: {:ok, right}

  def unwrap({_, x}), do: x

  def map({:ok, x}, fn_map), do: {:ok, fn_map.(x)}
  def map({:error, x}, _fn_map), do: {:error, x}

  def bind({:ok, x}, fn_map), do: fn_map.(x)
  def bind({:error, x}, _fn_map), do: {:error, x}

  def join({:ok, x1}, {:ok, x2}, fn_join), do: {:ok, fn_join.(x1, x2)}
  def join(err1, err2, _), do: {:error, List.flatten([err1, err2])}
end
