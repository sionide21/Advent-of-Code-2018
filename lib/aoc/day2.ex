defmodule AOC.Day2 do
  def has_repeat?(str, count) do
    str
    |> String.graphemes()
    |> Enum.sort()
    |> Enum.chunk_by(& &1)
    |> Enum.find(&(Enum.count(&1) == count))
  end

  def find_match([el | rest]) do
    length = String.length(el) - 1

    rest
    |> Enum.find(fn match ->
      Enum.count(union(el, match)) == length
    end)
    |> case do
      nil ->
        find_match(rest)

      match ->
        el
        |> union(match)
        |> Enum.join()
    end
  end

  def union(one, two) do
    [one, two]
    |> Enum.map(&String.graphemes/1)
    |> Enum.zip()
    |> Enum.flat_map(fn {a, b} ->
      if(a == b, do: [a], else: [])
    end)
  end
end
