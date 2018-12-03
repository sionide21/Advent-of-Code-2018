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
end
