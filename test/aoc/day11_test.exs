defmodule AOC.Day11Test do
  use ExUnit.Case, async: true
  alias AOC.Day11

  test "power" do
    assert Day11.power({3, 5}, 8) == 4
    assert Day11.power({122, 79}, 57) == -5
    assert Day11.power({217, 196}, 39) == 0
    assert Day11.power({101, 153}, 71) == 4
  end

  test "grid" do
    assert Day11.grid(5, 5, 18) ==  %{
      {1, 1} => -2, {1, 2} => -1, {1, 3} => 0, {1, 4} => 1, {1, 5} => 3,
      {2, 1} => -2, {2, 2} => 0, {2, 3} => 1, {2, 4} => 2, {2, 5} => 4,
      {3, 1} => -1, {3, 2} => 0, {3, 3} => 2, {3, 4} => 4, {3, 5} => -5,
      {4, 1} => -1, {4, 2} => 1, {4, 3} => 3, {4, 4} => -5, {4, 5} => -3,
      {5, 1} => -1, {5, 2} => 2, {5, 3} => 4, {5, 4} => -4, {5, 5} => -2
    }
  end

  test "best" do
    assert Day11.best(18) == {{33,45}, 29}
    assert Day11.best(42) == {{21,61}, 30}
    assert Day11.best(6878) == {{20, 34}, 30}
  end

  @tag timeout: :infinity
  test "best_ever" do
    assert Day11.best_ever(18) == {{90,269}, 16, 113}
    assert Day11.best_ever(42) == {{21,61}, 30}
    assert Day11.best_ever(6878) == 1
  end
end
