defmodule AOC.Day4Test do
  use ExUnit.Case, async: true
  alias AOC.Day4

  setup do
    {:ok,
     input:
       Enum.shuffle([
         "[1518-11-01 00:00] Guard #10 begins shift",
         "[1518-11-01 00:05] falls asleep",
         "[1518-11-01 00:25] wakes up",
         "[1518-11-01 00:30] falls asleep",
         "[1518-11-01 00:55] wakes up",
         "[1518-11-01 23:58] Guard #99 begins shift",
         "[1518-11-02 00:40] falls asleep",
         "[1518-11-02 00:50] wakes up",
         "[1518-11-03 00:05] Guard #10 begins shift",
         "[1518-11-03 00:24] falls asleep",
         "[1518-11-03 00:29] wakes up",
         "[1518-11-04 00:02] Guard #99 begins shift",
         "[1518-11-04 00:36] falls asleep",
         "[1518-11-04 00:46] wakes up",
         "[1518-11-05 00:03] Guard #99 begins shift",
         "[1518-11-05 00:45] falls asleep",
         "[1518-11-05 00:55] wakes up"
       ])}
  end

  test "parse", %{input: input} do
    assert Day4.parse(input) == [
             {10, 5, 25},
             {10, 30, 55},
             {99, 40, 50},
             {10, 24, 29},
             {99, 36, 46},
             {99, 45, 55}
           ]
  end
end
