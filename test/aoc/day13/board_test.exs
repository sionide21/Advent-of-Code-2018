defmodule AOC.Day13.BoardTest do
  use ExUnit.Case, async: true
  alias AOC.Day13.{Cart, Board}

  describe "parse" do
    test "lays tracks" do
      input = """
      /----\\
      |    |
      |    |
      \\----/
      """

      board = Board.parse(input)

      assert board.width == 6
      assert board.height == 4
      assert board.carts == %{}

      assert board.rails == %{
               {0, 0} => "/",
               {1, 0} => "-",
               {2, 0} => "-",
               {3, 0} => "-",
               {4, 0} => "-",
               {5, 0} => "\\",
               {0, 1} => "|",
               {5, 1} => "|",
               {0, 2} => "|",
               {5, 2} => "|",
               {0, 3} => "\\",
               {1, 3} => "-",
               {2, 3} => "-",
               {3, 3} => "-",
               {4, 3} => "-",
               {5, 3} => "/"
             }
    end

    test "places carts" do
      input = """
      /-<--\\
      v    |
      |    ^
      \\-->-/
      """

      board = Board.parse(input)

      assert Board.carts(board) == [
               %Cart{coord: {2, 0}, direction: "<"},
               %Cart{coord: {0, 1}, direction: "v"},
               %Cart{coord: {5, 2}, direction: "^"},
               %Cart{coord: {3, 3}, direction: ">"}
             ]

      assert board.rails[{2, 0}] == "-"
      assert board.rails[{0, 1}] == "|"
      assert board.rails[{5, 2}] == "|"
      assert board.rails[{3, 3}] == "-"
    end
  end
end
