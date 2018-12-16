defmodule AOC.Day15Test do
  use ExUnit.Case, async: true
  alias AOC.Day15

  test "players" do
    input = """
    #######
    #.G.E.#
    #E.G.E#
    #.G.E.#
    #######\
    """

    game = Day15.parse(input)

    assert to_string(game.board) == input

    assert game.players == %{
             {1, 2} => 200,
             {1, 4} => 200,
             {2, 1} => 200,
             {2, 3} => 200,
             {2, 5} => 200,
             {3, 2} => 200,
             {3, 4} => 200
           }
  end

  test "play_turn" do
    input = """
    #########
    #G..G..G#
    #.......#
    #.......#
    #G..E..G#
    #.......#
    #.......#
    #G..G..G#
    #########
    """

    game = Day15.parse(input)

    game = Day15.play_round(game)

    assert to_string(game.board) == """
           #########
           #.G...G.#
           #...G...#
           #...E..G#
           #.G.....#
           #.......#
           #G..G..G#
           #.......#
           #########\
           """

    assert game.players == %{
             {1, 2} => 200,
             {2, 4} => 197,
             {1, 6} => 200,
             {4, 2} => 200,
             {3, 4} => 200,
             {3, 7} => 200,
             {6, 1} => 200,
             {6, 4} => 200,
             {6, 7} => 200
           }

    game = Day15.play_round(game)

    assert to_string(game.board) == """
           #########
           #..G.G..#
           #...G...#
           #.G.E.G.#
           #.......#
           #G..G..G#
           #.......#
           #.......#
           #########\
           """

    assert game.players == %{
             {1, 3} => 200,
             {2, 4} => 194,
             {1, 5} => 200,
             {3, 2} => 200,
             {3, 4} => 197,
             {3, 6} => 200,
             {5, 1} => 200,
             {5, 4} => 200,
             {5, 7} => 200
           }

    game = Day15.play_round(game)

    assert to_string(game.board) == """
           #########
           #.......#
           #..GGG..#
           #..GEG..#
           #G..G...#
           #......G#
           #.......#
           #.......#
           #########\
           """

    assert game.players == %{
             {2, 3} => 200,
             {2, 4} => 191,
             {2, 5} => 200,
             {3, 3} => 200,
             {3, 4} => 185,
             {3, 5} => 200,
             {4, 1} => 200,
             {4, 4} => 200,
             {5, 7} => 200
           }
  end

  test "attacking" do
    input = """
    #######
    #.G...#
    #...EG#
    #.#.#G#
    #..G#E#
    #.....#
    #######
    """

    game = Day15.parse(input)

    game = Day15.play_round(game)

    assert to_string(game.board) == """
           #######
           #..G..#
           #...EG#
           #.#G#G#
           #...#E#
           #.....#
           #######\
           """

    assert game.players == %{
             {1, 3} => 200,
             {2, 4} => 197,
             {2, 5} => 197,
             {3, 3} => 200,
             {3, 5} => 197,
             {4, 5} => 197
           }
  end

  test "powerful elves" do
    input = """
    #######
    #.G...#
    #...EG#
    #.#.#G#
    #..G#E#
    #.....#
    #######
    """
    game = Day15.parse(input)
    game = %{game | elf_power: 50}
    game = Day15.play_round(game)

    assert to_string(game.board) == """
           #######
           #..G..#
           #...EG#
           #.#G#G#
           #...#E#
           #.....#
           #######\
           """

    assert game.players == %{
             {1, 3} => 200,
             {2, 4} => 197,
             {2, 5} => 150,
             {3, 3} => 200,
             {3, 5} => 150,
             {4, 5} => 197
           }
  end

  test "play_game" do
    input = """
    #######
    #G..#E#
    #E#E.E#
    #G.##.#
    #...#E#
    #...E.#
    #######\
    """

    game = Day15.parse(input)

    assert {game, 37} = Day15.play_game(game)

    assert to_string(game.board) == """
           #######
           #...#E#
           #E#...#
           #.E##.#
           #E..#E#
           #.....#
           #######\
           """

    assert game.players == %{
             {1, 5} => 200,
             {2, 1} => 197,
             {3, 2} => 185,
             {4, 1} => 200,
             {4, 5} => 200
           }
  end

  test "attack bug" do
    game =
      %Day15{
        board:
          Day15.Board.parse("""
          #######
          #..G..#
          #...EG#
          #.#G#G#
          #...#E#
          #.....#
          #######
          """),
        players: %{
          {1, 3} => 200,
          {2, 4} => 197,
          {2, 5} => 197,
          {3, 3} => 200,
          {3, 5} => 197,
          {4, 5} => 197
        }
      }
      |> Day15.play_round()

    assert game.players[{2, 4}] == 188
  end
end
