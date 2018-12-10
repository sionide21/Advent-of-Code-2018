defmodule AOC.Day9 do
  defstruct [:scores, :players, :board, :current]

  def from_string(str) do
    [_, players, turns] = Regex.run(~r/(\d+) players.+ (\d+) points/, str)
    play_game(String.to_integer(players), String.to_integer(turns))
  end

  def new(players) do
    %__MODULE__{
      scores: %{},
      players: players,
      board: [0],
      current: 0
    }
  end

  def play(game, marble) when rem(marble, 23) == 0 do
    player = rem(marble, game.players)
    position = mod(game.current - 7, length(game.board))
    {mine, board} = List.pop_at(game.board, position + 1)
    scores = Map.update(game.scores, player, mine + marble, &(&1 + mine + marble))

    %{game |
      board: board,
      current: position,
      scores: scores
    }
  end

  def play(game, marble) do
    position = rem(game.current + 2, length(game.board))

    %{game | board: List.insert_at(game.board, position + 1, marble), current: position}
  end

  def play_game(players, turns) do
    Enum.reduce(1..(turns), new(players), fn turn, game ->
      play(game, turn)
    end)
  end

  def high_score(%{scores: scores}) do
    scores
    |> Map.values()
    |> Enum.max()
  end

  defp mod(x, y) when x > 0 do
    rem(x, y)
  end
  defp mod(x, y) when x <= 0 and y > abs(x) do
    y + x
  end
end
