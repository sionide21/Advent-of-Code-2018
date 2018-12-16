defmodule AOC.Day14 do
  defstruct elves: [0, 1], index: 2, recipes: %{0 => 3, 1 => 7}

  def next_ten(input) do
    do_next_ten(%__MODULE__{}, input + 10)
  end

  defp do_next_ten(%{index: index} = chart, target) when target > index do
    chart
    |> merge()
    |> do_next_ten(target)
  end

  defp do_next_ten(chart, target) do
    (target - 10)..(target - 1)
    |> Enum.map(&Map.fetch!(chart.recipes, &1))
    |> Enum.join()
  end

  def first_seen(input) do
    target =
      input
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)

    do_first_seen(%__MODULE__{}, target, target)
  end

  defp do_first_seen(chart, needed, target) do
    chart
    |> next_recipes()
    |> Enum.reduce_while({0, needed}, fn
      r, {i, [r | rest]} ->
        {:cont, {i + 1, rest}}

      _, {i, []} ->
        {:halt, {i + 1, []}}

      x, {i, _} ->
        case target do
          [^x | rest] -> {:cont, {i + 1, rest}}
          t -> {:cont, {i + 1, t}}
        end
    end)
    |> case do
      {i, []} ->
        chart.recipes
        |> Enum.count()
        |> Kernel.+(i)
        |> Kernel.-(length(target))

      {_, needed} ->
        chart
        |> merge()
        |> do_first_seen(needed, target)
    end
  end

  def next_recipes(chart) do
    chart.elves
    |> Enum.map(&Map.fetch!(chart.recipes, &1))
    |> Enum.sum()
    |> Integer.digits()
  end

  def merge(chart) do
    {recipes, index} =
      chart
      |> next_recipes()
      |> Enum.reduce({chart.recipes, chart.index}, fn recipe, {recipes, index} ->
        {Map.put(recipes, index, recipe), index + 1}
      end)

    elves =
      Enum.map(chart.elves, fn elf ->
        chart.recipes
        |> Map.fetch!(elf)
        |> Kernel.+(elf + 1)
        |> rem(index)
      end)

    %{chart | elves: elves, recipes: recipes, index: index}
  end

  defimpl Inspect, for: __MODULE__ do
    def inspect(%{elves: elves, recipes: recipes, index: index}, _opts) do
      0..(index - 1)
      |> Enum.map(fn i ->
        case {Map.fetch!(recipes, i), Enum.member?(elves, i)} do
          {r, true} -> "(#{r})"
          {r, false} -> " #{r} "
        end
      end)
      |> Enum.join()
    end
  end
end
