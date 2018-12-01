defmodule AOCTest do
  use ExUnit.Case
  doctest AOC

  test "Day 1 part 1" do
    assert AOC.day1([+1, +1, +1]) == 3
    assert AOC.day1([+1, +1, -2]) == 0
    assert AOC.day1([-1, -2, -3]) == -6

    AOC.input(1)
    |> Enum.map(&AOC.to_integer/1)
    |> AOC.day1()
    |> IO.inspect(label: "Day 1")
  end

  test "Day 1 part 2" do
    assert AOC.day1_2([+1, -1]) == 0
    assert AOC.day1_2([+3, +3, +4, -2, -4]) == 10
    assert AOC.day1_2([-6, +3, +8, +5, -6]) == 5
    assert AOC.day1_2([+7, +7, -2, -7, -4]) == 14

    AOC.input(1)
    |> Enum.map(&AOC.to_integer/1)
    |> AOC.day1_2()
    |> IO.inspect(label: "Day 1 Part 2")
  end
end
