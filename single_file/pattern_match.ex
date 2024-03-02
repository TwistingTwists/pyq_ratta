defmodule PatternMatch do
    def print_now([ ]) do 
        IO.puts("empty list!")
    end

  def print_now([head | tail ]) do 
    IO.puts("h: #{head}, t: #{inspect tail}")
    print_now(tail)
  end

  
end

PatternMatch.print_now([1,2,3,4,5])