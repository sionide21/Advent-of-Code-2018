defmodule AOCTest do
  use ExUnit.Case, async: true
  doctest AOC

  test "Day 1 part 1" do
    assert AOC.day("1", "1", [+1, +1, +1]) == 3
    assert AOC.day("1", "1", [+1, +1, -2]) == 0
    assert AOC.day("1", "1", [-1, -2, -3]) == -6
  end

  test "Day 1 part 2" do
    assert AOC.day("1", "2", [+1, -1]) == 0
    assert AOC.day("1", "2", [+3, +3, +4, -2, -4]) == 10
    assert AOC.day("1", "2", [-6, +3, +8, +5, -6]) == 5
    assert AOC.day("1", "2", [+7, +7, -2, -7, -4]) == 14
  end

  test "Day 2 part 1" do
    input = ~w[
      abcdef
      bababc
      abbcde
      abcccd
      aabcdd
      abcdee
      ababab
    ]
    assert AOC.day("2", "1", input) == 12
  end

  test "Day 2 part 2" do
    input = ~w[
      abcde
      fghij
      klmno
      pqrst
      fguij
      axcye
      wvxyz
    ]
    assert AOC.day("2", "2", input) == "fgij"
  end

  test "Day 3 part 1" do
    input = [
      "#1 @ 1,3: 4x4",
      "#2 @ 3,1: 4x4",
      "#3 @ 5,5: 2x2"
    ]

    assert AOC.day("3", "1", input) == 4
  end

  test "Day 3 part 2" do
    input = [
      "#1 @ 1,3: 4x4",
      "#2 @ 3,1: 4x4",
      "#3 @ 5,5: 2x2"
    ]

    assert AOC.day("3", "2", input) == 3
  end

  test "Day 4 part 1" do
    input =
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
      ])

    assert AOC.day("4", "1", input) == 240
  end

  test "Day 4 part 2" do
    input =
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
      ])

    assert AOC.day("4", "2", input) == 4455
  end

  test "Day 5 part 1" do
    assert AOC.day("5", "1", "dabAcCaCBAcCcaDA") == 10
  end

  test "Day 5 part 2" do
    assert AOC.day("5", "2", "dabAcCaCBAcCcaDA") == 4
  end
end
