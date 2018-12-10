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

  test "Day 6 part 1" do
    input = [
      {1, 1},
      {1, 6},
      {8, 3},
      {3, 4},
      {5, 5},
      {8, 9}
    ]

    assert AOC.day("6", "1", input) == 17
  end

  test "Day 6 part 2" do
    input = [
      {1, 1},
      {1, 6},
      {8, 3},
      {3, 4},
      {5, 5},
      {8, 9}
    ]

    # ಠ_ಠ
    assert AOC.Day6.area_within_distance(input, 32) == 16
  end

  test "Day 7 part 1" do
    input = [
      "Step C must be finished before step A can begin.",
      "Step C must be finished before step F can begin.",
      "Step A must be finished before step B can begin.",
      "Step A must be finished before step D can begin.",
      "Step B must be finished before step E can begin.",
      "Step D must be finished before step E can begin.",
      "Step F must be finished before step E can begin."
    ]

    assert AOC.day("7", "1", input) == "CABDFE"
  end

  test "Day 7 part 2" do
    input = [
      "Step C must be finished before step A can begin.",
      "Step C must be finished before step F can begin.",
      "Step A must be finished before step B can begin.",
      "Step A must be finished before step D can begin.",
      "Step B must be finished before step E can begin.",
      "Step D must be finished before step E can begin.",
      "Step F must be finished before step E can begin."
    ]

    answer =
      input
      |> AOC.Day7.build_graph()
      |> AOC.Day7.process(2, 0)

    assert answer == 15
  end

  test "Day 8 part 1" do
    input = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"
    assert AOC.day("8", "1", input) == 138
  end

  test "Day 8 part 2" do
    input = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"
    assert AOC.day("8", "2", input) == 66
  end

  test "Day 9 part 1" do
    assert AOC.day("9", "1", "9 players; last marble is worth 25 points") == 32
    assert AOC.day("9", "1", "10 players; last marble is worth 1618 points") == 8317
    assert AOC.day("9", "1", "13 players; last marble is worth 7999 points") == 146_373
    assert AOC.day("9", "1", "17 players; last marble is worth 1104 points") == 2764
    assert AOC.day("9", "1", "21 players; last marble is worth 6111 points") == 54718
    assert AOC.day("9", "1", "30 players; last marble is worth 5807 points") == 37305
  end

  test "Day 10 part 1" do
    input = """
    position=< 9,  1> velocity=< 0,  2>
    position=< 7,  0> velocity=<-1,  0>
    position=< 3, -2> velocity=<-1,  1>
    position=< 6, 10> velocity=<-2, -1>
    position=< 2, -4> velocity=< 2,  2>
    position=<-6, 10> velocity=< 2, -2>
    position=< 1,  8> velocity=< 1, -1>
    position=< 1,  7> velocity=< 1,  0>
    position=<-3, 11> velocity=< 1, -2>
    position=< 7,  6> velocity=<-1, -1>
    position=<-2,  3> velocity=< 1,  0>
    position=<-4,  3> velocity=< 2,  0>
    position=<10, -3> velocity=<-1,  1>
    position=< 5, 11> velocity=< 1, -2>
    position=< 4,  7> velocity=< 0, -1>
    position=< 8, -2> velocity=< 0,  1>
    position=<15,  0> velocity=<-2,  0>
    position=< 1,  6> velocity=< 1,  0>
    position=< 8,  9> velocity=< 0, -1>
    position=< 3,  3> velocity=<-1,  1>
    position=< 0,  5> velocity=< 0, -1>
    position=<-2,  2> velocity=< 2,  0>
    position=< 5, -2> velocity=< 1,  2>
    position=< 1,  4> velocity=< 2,  1>
    position=<-2,  7> velocity=< 2, -2>
    position=< 3,  6> velocity=<-1, -1>
    position=< 5,  0> velocity=< 1,  0>
    position=<-6,  0> velocity=< 2,  0>
    position=< 5,  9> velocity=< 1, -2>
    position=<14,  7> velocity=<-2,  0>
    position=<-3,  6> velocity=< 2, -1>
    """

    assert AOC.day("10", "1", input) == """

           #...#..###
           #...#...#.
           #...#...#.
           #####...#.
           #...#...#.
           #...#...#.
           #...#...#.
           #...#..###\
           """
  end

  test "Day 10 part 2" do
    input = """
    position=< 9,  1> velocity=< 0,  2>
    position=< 7,  0> velocity=<-1,  0>
    position=< 3, -2> velocity=<-1,  1>
    position=< 6, 10> velocity=<-2, -1>
    position=< 2, -4> velocity=< 2,  2>
    position=<-6, 10> velocity=< 2, -2>
    position=< 1,  8> velocity=< 1, -1>
    position=< 1,  7> velocity=< 1,  0>
    position=<-3, 11> velocity=< 1, -2>
    position=< 7,  6> velocity=<-1, -1>
    position=<-2,  3> velocity=< 1,  0>
    position=<-4,  3> velocity=< 2,  0>
    position=<10, -3> velocity=<-1,  1>
    position=< 5, 11> velocity=< 1, -2>
    position=< 4,  7> velocity=< 0, -1>
    position=< 8, -2> velocity=< 0,  1>
    position=<15,  0> velocity=<-2,  0>
    position=< 1,  6> velocity=< 1,  0>
    position=< 8,  9> velocity=< 0, -1>
    position=< 3,  3> velocity=<-1,  1>
    position=< 0,  5> velocity=< 0, -1>
    position=<-2,  2> velocity=< 2,  0>
    position=< 5, -2> velocity=< 1,  2>
    position=< 1,  4> velocity=< 2,  1>
    position=<-2,  7> velocity=< 2, -2>
    position=< 3,  6> velocity=<-1, -1>
    position=< 5,  0> velocity=< 1,  0>
    position=<-6,  0> velocity=< 2,  0>
    position=< 5,  9> velocity=< 1, -2>
    position=<14,  7> velocity=<-2,  0>
    position=<-3,  6> velocity=< 2, -1>
    """

    assert AOC.day("10", "2", input) == 3
  end
end
