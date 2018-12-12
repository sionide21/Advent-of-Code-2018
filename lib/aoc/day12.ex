defmodule AOC.Day12 do
  def grow(current, rules) do
    [".", ".", ".", "." | current ++ [".", ".", ".", ".", "."]]
    |> Enum.chunk_every(5, 1)
    |> Enum.map(&Map.get(rules, &1, "."))
  end

  def count(start, generations, rules) do
    1..generations
    |> Enum.reduce(start, fn _, pots -> grow(pots, rules) end)
    |> add(-2 * generations)
  end

  def add(pots, leftmost) do
    {count, _} =
      Enum.reduce(pots, {0, leftmost}, fn
        ".", {count, i} -> {count, i + 1}
        "#", {count, i} -> {count + i, i + 1}
      end)
    count
  end

  def compile_rules(rules) do
    rules
    |> Enum.map(fn {k, v} -> {String.graphemes(k), v} end)
    |> Map.new()
  end
end
