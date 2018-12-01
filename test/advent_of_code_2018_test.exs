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
end
