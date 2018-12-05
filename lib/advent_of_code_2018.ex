defmodule AOC do
  def read_file(day) do
    File.stream!("inputs/day#{day}.txt")
    |> Stream.map(&String.trim/1)
  end

  def input("1") do
    read_file(1) |> Enum.map(&String.to_integer/1)
  end

  def input("5") do
    read_file(5) |> Enum.at(0)
  end

  def input(day) do
    read_file(day)
  end

  def day("1", "1", input) do
    Enum.sum(input)
  end

  def day("1", "2", input) do
    input
    |> Stream.cycle()
    |> Stream.scan(&(&1 + &2))
    |> Stream.drop(1)
    |> Enum.reduce_while(MapSet.new(), fn x, seen ->
      if MapSet.member?(seen, x) do
        {:halt, x}
      else
        {:cont, MapSet.put(seen, x)}
      end
    end)
  end

  def day("2", "1", input) do
    twos = Enum.count(input, &AOC.Day2.has_repeat?(&1, 2))
    threes = Enum.count(input, &AOC.Day2.has_repeat?(&1, 3))

    twos * threes
  end

  def day("2", "2", input) do
    input
    |> Enum.to_list()
    |> AOC.Day2.find_match()
  end

  def day("3", "1", input) do
    input
    |> Enum.map(&AOC.Day3.parse/1)
    |> AOC.Day3.build_map(fn fabric, _claim, coord ->
      Map.update(fabric, coord, 1, &(&1 + 1))
    end)
    |> Enum.filter(fn {_, claims} -> claims > 1 end)
    |> Enum.count()
  end

  def day("3", "2", input) do
    claims = Enum.map(input, &AOC.Day3.parse/1)
    all = Enum.map(claims, & &1.id)

    [unique] =
      claims
      |> AOC.Day3.build_map(fn fabric, claim, coord ->
        Map.update(fabric, coord, [claim.id], &[claim.id | &1])
      end)
      |> Enum.reduce(all, fn
        {_, [_]}, uniques -> uniques
        {_, dups}, uniques -> uniques -- dups
      end)

    unique
  end

  def day("4", "1", input) do
    input
    |> AOC.Day4.parse()
    |> AOC.Day4.sleep_schedules()
    |> Enum.max_by(fn {_, schedule} ->
      schedule
      |> Map.values()
      |> Enum.sum()
    end)
    |> case do
      {guard, schedule} ->
        {minute, _} = Enum.max_by(schedule, fn {_, v} -> v end)
        minute * guard
    end
  end

  def day("4", "2", input) do
    input
    |> AOC.Day4.parse()
    |> AOC.Day4.sleep_schedules()
    |> Enum.max_by(fn {_, schedule} ->
      schedule
      |> Map.values()
      |> Enum.max()
    end)
    |> case do
      {guard, schedule} ->
        {minute, _} = Enum.max_by(schedule, fn {_, v} -> v end)
        minute * guard
    end
  end

  def day("5", "1", input) do
    input
    |> String.to_charlist()
    |> AOC.Day5.reaction_length()
  end

  def day("5", "2", input) do
    input
    |> String.to_charlist()
    |> AOC.Day5.permutations()
    |> Enum.map(&AOC.Day5.reaction_length(&1))
    |> Enum.min()
  end

  def day(_, _, _) do
    "Not Implemented"
  end
end
