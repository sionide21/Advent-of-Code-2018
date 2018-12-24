defmodule AOC.Day23 do
  alias __MODULE__.Bot

  def parse(input) do
    input
    |> Enum.map(fn line ->
      ~r/^pos=<(?<x>-?\d+),(?<y>-?\d+),(?<z>-?\d+)>, r=(?<r>\d+)$/
      |> Regex.run(line, capture: :all_but_first)
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.map(fn [x, y, z, r] ->
      %Bot{x: x, y: y, z: z, r: r}
    end)
  end
end
