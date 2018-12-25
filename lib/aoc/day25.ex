defmodule AOC.Day25 do
  def parse(input) do
    Enum.map(input, fn row ->
      row
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def constellations(points) do
    Enum.reduce(points, [], fn point, constellations ->
      {joined, rest} = find_constellations(constellations, point)
      new_const = [point | Enum.flat_map(joined, & &1)]
      [new_const | rest]
    end)
  end

  def find_constellations(constellations, point) do
    Enum.split_with(constellations, fn constellation ->
      member?(constellation, point)
    end)
  end

  def member?(constellation, point) do
    Enum.any?(constellation, &(distance(&1, point) <= 3))
  end

  def distance(a, b) do
    a
    |> Enum.zip(b)
    |> Enum.map(fn {a, b} -> abs(a - b) end)
    |> Enum.sum()
  end
end
