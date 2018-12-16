defmodule AOC.Day15.BoardTest do
  use ExUnit.Case, async: true
  alias AOC.Day15.Board

  test "parse" do
    input = """
    #######
    #G..#E#
    #E#E.E#
    #G.##.#
    #...#E#
    #...E.#
    #######
    """

    assert Board.parse(input) |> to_string() == String.trim(input)
  end

  test "bfs" do
    input = """
    #######
    #LD5EM#
    #F617G#
    #8203A#
    #H94BJ#
    #NICKO#
    #######
    """

    visitable? = &(&1 != "#")

    result =
      input
      |> Board.parse()
      |> Board.bfs(visitable?, {3, 3}, [], fn {_, el, _}, acc ->
        {:cont, [el | acc]}
      end)
      |> Enum.reverse()
      |> Enum.join()

    assert result == "123456789ABCDEFGHIJKLMNO"
  end

  test "bfs skips unvisitable" do
    input = """
    #######
    #0#6G.#
    #1E5G.#
    #234G.#
    #EEE..#
    #.....#
    #######
    """

    visitable? = &(&1 == "." || Integer.parse(&1) !== :error)

    result =
      input
      |> Board.parse()
      |> Board.bfs(visitable?, {1, 1}, [], fn {_, el, _}, acc ->
        {:cont, [el | acc]}
      end)
      |> Enum.reverse()
      |> Enum.join()

    assert result == "123456"
  end

  test "shortest_path" do
    input = """
    #######
    #.E...#
    #.....#
    #...G.#
    #######
    """
    board = Board.parse(input)
    visitable? = &(&1 == ".")
    {:ok, result} = Board.shortest_path(board, visitable?, {1, 2}, "G")

    assert result == [{1, 3}, {1, 4}, {2, 4}, {3, 4}]
  end

  test "shortest_path with neighbor" do
    input = """
    #######
    #GE...#
    #.....#
    #.....#
    #######
    """
    board = Board.parse(input)
    visitable? = &(&1 == ".")
    {:ok, result} = Board.shortest_path(board, visitable?, {1, 2}, "G")

    assert result == [{1, 1}]
  end

  test "shortest_path not possible" do
    input = """
    #######
    #.E...#
    #...###
    #...#G#
    #######
    """
    board = Board.parse(input)
    visitable? = &(&1 == ".")
    assert :error = Board.shortest_path(board, visitable?, {1, 2}, "G")
  end

  test "players" do
    input = """
    #######
    #.G.E.#
    #E.G.E#
    #.G.E.#
    #######
    """
    board = Board.parse(input)
    character? = &(&1 in ["E", "G"])

    assert Board.players(board, character?) == [
      {{1, 2}, "G"},
      {{1, 4}, "E"},
      {{2, 1}, "E"},
      {{2, 3}, "G"},
      {{2, 5}, "E"},
      {{3, 2}, "G"},
      {{3, 4}, "E"}
    ]
  end

  test "current?" do
    input = """
    #######
    #.G.E.#
    #E.G.E#
    #.G.E.#
    #######
    """
    board = Board.parse(input)

    assert Board.current?(board, {{1, 2}, "G"})
    refute Board.current?(board, {{1, 3}, "G"})
    refute Board.current?(board, {{1, 2}, "E"})
  end

  test "move" do
    input = """
    #######
    #.G.E.#
    #E.G.E#
    #.G.E.#
    #######
    """
    board = Board.parse(input)

    assert Board.move(board, {1, 2}, {2, 2}) |> to_string() == """
    #######
    #...E.#
    #EGG.E#
    #.G.E.#
    #######\
    """
    assert Board.move(board, {1, 2}, {1, 3}) |> to_string() == """
    #######
    #..GE.#
    #E.G.E#
    #.G.E.#
    #######\
    """
  end
end
