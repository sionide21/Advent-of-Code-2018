defmodule AOC.Day18 do
  def parse(input) do
    input
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, y} ->
      row
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.map(fn {square, x} ->
        {{x, y}, square}
      end)
    end)
    |> Map.new()
  end

  def count_after(start, time) do
    1..time
    |> Enum.reduce(start, fn _, grid ->
      change(grid)
    end)
    |> Map.values()
    |> count()
  end

  def cycle_length(grid, skip) do
    grid =
      Enum.reduce(1..skip, grid, fn _, grid ->
        change(grid)
      end)

    find_cycle(grid, change(grid), 1)
  end

  defp find_cycle(start, grid, time) when grid == start do
    time
  end

  defp find_cycle(start, grid, time) do
    find_cycle(start, change(grid), time + 1)
  end

  def change(grid) do
    grid
    |> Enum.reduce(%{}, fn {square, type}, new_grid ->
      new_type =
        case {type, count_neighbors(grid, square)} do
          {".", {_, trees, _}} when trees >= 3 ->
            "|"

          {"|", {_, _, lumber}} when lumber >= 3 ->
            "#"

          {"#", {_, trees, lumber}} when trees > 0 and lumber > 0 ->
            "#"

          {"#", _} ->
            "."

          {v, _} ->
            v
        end

      Map.put(new_grid, square, new_type)
    end)
  end

  def count_neighbors(grid, square) do
    square
    |> neighbors()
    |> Enum.map(&Map.get(grid, &1, "."))
    |> count()
  end

  def count(squares) do
    Enum.reduce(squares, {0, 0, 0}, fn neighbor, {open, trees, lumber} ->
      case neighbor do
        "." ->
          {open + 1, trees, lumber}

        "|" ->
          {open, trees + 1, lumber}

        "#" ->
          {open, trees, lumber + 1}
      end
    end)
  end

  def neighbors({x, y}) do
    for dx <- -1..1, dy <- -1..1, dx != 0 or dy != 0, do: {x + dx, y + dy}
  end

  def print(grid, time) do
    output =
      grid
      |> Enum.sort_by(fn {{x, y}, _} -> {y, x} end)
      |> Enum.map(fn
        {{0, _}, v} -> "\n" <> v
        {_, v} -> v
      end)
      |> Enum.join()

    IO.puts("#{IO.ANSI.clear()}#{IO.ANSI.cursor(0, 0)}Time: #{time}\n#{output}")

    grid
  end
end
