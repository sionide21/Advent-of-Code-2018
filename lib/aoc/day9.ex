defmodule AOC.Day9 do
  defstruct [:scores, :players, :board]

  alias __MODULE__.Board

  def from_string(str) do
    [_, players, turns] = Regex.run(~r/(\d+) players.+ (\d+) points/, str)
    play_game(String.to_integer(players), String.to_integer(turns))
  end

  def new(players) do
    %__MODULE__{
      scores: %{},
      players: players,
      board: Board.new()
    }
  end

  def play(game, marble) when rem(marble, 23) == 0 do
    player = rem(marble, game.players)

    {mine, board} =
      game.board
      |> Board.move(-7)
      |> Board.pop()

    scores = Map.update(game.scores, player, mine + marble, &(&1 + mine + marble))

    %{game | board: board, scores: scores}
  end

  def play(game, marble) do
    board =
      game.board
      |> Board.move(1)
      |> Board.place(marble)

    %{game | board: board}
  end

  def play_game(players, turns) do
    Enum.reduce(1..turns, new(players), fn turn, game ->
      play(game, turn)
    end)
  end

  def high_score(%{scores: scores}) do
    scores
    |> Map.values()
    |> Enum.max()
  end
end
