defmodule AOC do
  def input(day) do
    File.stream!("inputs/day#{day}.txt")
  end

  def to_integer(str) do
    str
    |> String.trim()
    |> String.to_integer()
  end

  def day1(input) do
    Enum.sum(input)
  end

  def day1_2(input) do
    input
    |> Stream.cycle
    |> Stream.scan((& &1 + &2))
    |> Stream.drop(1)
    |> Enum.reduce_while(MapSet.new(), fn x, seen ->
      if MapSet.member?(seen, x) do
        {:halt, x}
      else
        {:cont, MapSet.put(seen, x)}
      end
    end)
  end
end
