defmodule AOC do
  def file_path(day) do
    "inputs/day#{day}.txt"
  end

  def read_file(day) do
    day
    |> file_path()
    |> File.stream!()
    |> Stream.map(&String.trim/1)
  end

  def input("1") do
    read_file(1) |> Enum.map(&String.to_integer/1)
  end

  def input("5") do
    read_file(5) |> Enum.at(0)
  end

  def input("6") do
    read_file(6)
    |> Enum.map(fn str ->
      [x, y] =
        str
        |> String.split(", ")
        |> Enum.map(&String.to_integer/1)

      {x, y}
    end)
  end

  def input("8") do
    read_file(8) |> Enum.at(0)
  end

  def input("9") do
    read_file(9) |> Enum.at(0)
  end

  def input("10") do
    read_file(10) |> Enum.join()
  end

  def input("13") do
    File.read!(file_path(13))
  end

  def input("15") do
    File.read!(file_path(15))
  end

  def input("16") do
    {read_file("16_1"), read_file("16_2")}
  end

  def input("19") do
    read_file("19_fast")
  end

  def input("24") do
    {read_file("24_immune"), read_file("24_infection")}
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

  def day("6", "1", input) do
    AOC.Day6.largest_area(input)
  end

  def day("6", "2", input) do
    AOC.Day6.area_within_distance(input, 10000)
  end

  def day("7", "1", input) do
    input
    |> AOC.Day7.build_graph()
    |> AOC.Day7.flatten()
    |> Enum.join()
  end

  def day("7", "2", input) do
    input
    |> AOC.Day7.build_graph()
    |> AOC.Day7.process(5, 60)
  end

  def day("8", "1", input) do
    input
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> AOC.Day8.sum()
  end

  def day("8", "2", input) do
    input
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> AOC.Day8.value()
  end

  def day("9", "1", input) do
    {players, turns} = AOC.Day9.parse(input)

    players
    |> AOC.Day9.play_game(turns)
    |> AOC.Day9.high_score()
  end

  def day("9", "2", input) do
    {players, turns} = AOC.Day9.parse(input)

    players
    |> AOC.Day9.play_game(turns * 100)
    |> AOC.Day9.high_score()
  end

  def day("10", "1", input) do
    input
    |> AOC.Day10.parse()
    |> AOC.Day10.solve()
    |> (&("\n" <> &1)).()
  end

  def day("10", "2", input) do
    input
    |> AOC.Day10.parse()
    |> AOC.Day10.time()
  end

  def day("13", "1", input) do
    input
    |> AOC.Day13.parse_board()
    |> AOC.Day13.first_crash()
    |> AOC.Day13.output_coords()
  end

  def day("13", "2", input) do
    input
    |> AOC.Day13.parse_board()
    |> AOC.Day13.last_cart()
    |> AOC.Day13.output_coords()
  end

  def day("15", "1", input) do
    {game, rounds} =
      input
      |> AOC.Day15.parse()
      |> AOC.Day15.play_game()

    game.players
    |> Map.values()
    |> Enum.sum()
    |> Kernel.*(rounds)
  end

  def day("15", "2", input) do
    {game, rounds} =
      input
      |> AOC.Day15.parse()
      |> AOC.Day15.elves_win()

    game.players
    |> Map.values()
    |> Enum.sum()
    |> Kernel.*(rounds)
  end

  def day("16", "1", {input, _}) do
    input
    |> AOC.Day16.parse_part1()
    |> Enum.map(fn [input, {_, a, b, c}, output] ->
      AOC.Day16.possible_ops(input, {a, b, c}, output)
      |> Enum.count()
    end)
    |> Enum.count(&(&1 >= 3))
  end

  def day("16", "2", {_, input}) do
    input
    |> AOC.Day16.parse_part2()
    |> Enum.reduce({0, 0, 0, 0}, &AOC.Day16.op/2)
    |> elem(0)
  end

  def day("18", "1", input) do
    {_open, trees, lumber} =
      input
      |> AOC.Day18.parse()
      |> AOC.Day18.count_after(10)

    trees * lumber
  end

  def day("18", "2", input) do
    grid = AOC.Day18.parse(input)
    cycle = AOC.Day18.cycle_length(grid, 1000)
    similar = rem(1_000_000_000 - 1000, cycle) + 1000
    {_open, trees, lumber} = AOC.Day18.count_after(grid, similar)

    trees * lumber
  end

  def day("19", "1", input) do
    program =
      input
      |> Enum.to_list()
      |> AOC.Day19.parse()
      |> AOC.Day19.run()

    elem(program.registers, 0)
  end

  def day("19", "2", input) do
    program =
      input
      |> Enum.to_list()
      |> AOC.Day19.parse()

    program =
      %{program | registers: {1, 0, 0, 0, 0, 0}}
      |> AOC.Day19.run()

    elem(program.registers, 0)
  end

  def day("22", "1", input) do
    input
    |> AOC.Day22.parse()
    |> AOC.Day22.risk()
    |> elem(1)
  end

  def day("22", "2", input) do
    input
    |> AOC.Day22.parse()
    |> AOC.Day22.shortest_path()
  end

  def day("23", "1", input) do
    bots = AOC.Day23.parse(input)
    best = Enum.max_by(bots, &(&1.r))
    bots
    |> Enum.count(fn bot ->
      AOC.Day23.Bot.dist(bot, best) <= best.r
    end)
  end

  def day("23", "2", input) do
    input
    |> AOC.Day23.parse()
    |> AOC.Day23.best_region()
    |> elem(1)
    |> IO.inspect
  end

  def day("24", "1", input) do
    input
    |> AOC.Day24.parse()
    |> AOC.Day24.fight()
    |> elem(1)
    |> Map.values()
    |> Enum.map(&(&1.units))
    |> Enum.sum()
  end

  def day("24", "2", input) do
    input
    |> AOC.Day24.parse()
    |> AOC.Day24.boost(1)
    |> Map.values()
    |> Enum.map(&(&1.units))
    |> Enum.sum()
  end

  def day("25", "1", input) do
    input
    |> AOC.Day25.parse()
    |> AOC.Day25.constellations()
    |> Enum.count()
  end

  def day(_, _, _) do
    "Not Implemented"
  end
end
