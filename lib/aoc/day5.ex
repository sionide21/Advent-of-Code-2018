defmodule AOC.Day5 do
  def react(input) do
    do_react(input, [], false)
  end

  def do_react([a, b | rest], acc, _) when abs(a - b) == 32 do
    do_react(rest, acc, true)
  end

  def do_react([a, b | rest], acc, reacted?) do
    do_react([b | rest], [a | acc], reacted?)
  end

  def do_react([b], acc, reacted?) do
    do_react([], [b | acc], reacted?)
  end

  def do_react([], acc, true) do
    acc
    |> Enum.reverse()
    |> react()
  end

  def do_react([], acc, false) do
    Enum.reverse(acc)
  end

  def reaction_length(input) do
    input
    |> react()
    |> Enum.count()
  end

  def permutations(input) do
    input
    |> :string.lowercase()
    |> Enum.uniq()
    |> Enum.map(fn letter ->
      input
      |> Enum.reject(&(&1 == letter))
      |> Enum.reject(&(&1 == letter - 32))
    end)
  end
end
