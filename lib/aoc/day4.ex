defmodule AOC.Day4 do
  def parse(input) do
    input
    |> Enum.sort()
    |> Enum.map(&parse_line/1)
    |> Enum.chunk_while(nil, fn
      {_, {:gaurd, guard}}, _ -> {:cont, guard}
      {sleep, :sleep}, guard -> {:cont, {guard, sleep}}
      {wake, :wake}, {guard, sleep} -> {:cont, {guard, sleep, wake}, guard}
    end, fn _ -> {:cont, nil} end)
  end

  def sleep_schedules(events) do
    Enum.reduce(events, %{}, fn {guard, sleep, wake}, acc ->
      schedule = Map.get(acc, guard, %{})
      schedule = Enum.reduce(sleep..(wake-1), schedule, fn minute, schedule ->
        Map.update(schedule, minute, 1, &(&1 + 1))
      end)
      Map.put(acc, guard, schedule)
    end)
  end

  def parse_line(line) do
    [_, time, event] =
      ~r/:(\d\d)] (.+)$/
      |> Regex.run(line)
    {String.to_integer(time), parse_event(event)}
  end

  def parse_event("Guard #" <> rest) do
    {n, _} = Integer.parse(rest)
    {:gaurd, n}
  end
  def parse_event("falls asleep") do
    :sleep
  end
  def parse_event("wakes up") do
    :wake
  end
end
