defmodule AOC.Day15 do
  alias __MODULE__.Board
  defstruct [:board, :players, elf_power: 3]

  def parse(input) do
    board = Board.parse(input)

    players =
      board
      |> Board.players(&is_character?/1)
      |> Map.new(fn {coord, _} -> {coord, 200} end)

    %__MODULE__{
      board: board,
      players: players
    }
  end

  def play_round(game) do
    game.board
    |> Board.players(&is_character?/1)
    |> Enum.reduce(game, fn {coord, team}, game ->
      if Board.current?(game.board, {coord, team}) do
        game.board
        |> Board.shortest_path(&is_passable?/1, coord, enemy(team))
        |> case do
          {:ok, [_]} ->
            attack(game, coord, team)

          {:ok, [move | _]} ->
            board = Board.move(game.board, coord, move)
            players = move_player(game.players, coord, move)

            %{game | board: board, players: players}
            |> attack(move, team)

          :error ->
            game
        end
      else
        game
      end
    end)
  end

  def attack(game, coord, team) do
    game.board
    |> Board.neighbors(coord, enemy(team))
    |> case do
      [] ->
        game

      neighbors ->
        target = Enum.min_by(neighbors, &Map.fetch!(game.players, &1))
        power = if(team == "E", do: game.elf_power, else: 3)

        {board, players} =
          game.players
          |> Map.fetch!(target)
          |> case do
            health when health <= power ->
              {Board.remove(game.board, target), Map.delete(game.players, target)}

            health ->
              {game.board, Map.put(game.players, target, health - power)}
          end

        %{game | players: players, board: board}
    end
  end

  def elves_win(game) do
    needed_elves = elf_count(game)
    do_elves_win(game, needed_elves)
  end

  defp do_elves_win(game, needed_elves) do
    {finished_game, rounds} = play_game(game)

    if elf_count(finished_game) == needed_elves do
      {finished_game, rounds}
    else
      do_elves_win(%{game | elf_power: game.elf_power + 1}, needed_elves)
    end
  end

  def play_game(game) do
    do_play_game(game, 0)
  end

  defp do_play_game(game, round) do
    # display =
    #   game.board
    #   |> inspect()
    #   |> String.replace(".", " ")
    #   |> String.replace("#", "#{IO.ANSI.light_black_background} #{IO.ANSI.reset}")
    # IO.puts("#{IO.ANSI.clear()}#{IO.ANSI.cursor(0, 0)}Round: #{round}\n#{display}")
    # IO.inspect()
    # IO.inspect(game.players)
    # Process.sleep(100)
    game = play_round(game)

    game.board
    |> Board.players(&is_character?/1)
    |> Enum.map(&elem(&1, 1))
    |> Enum.uniq()
    |> case do
      [_] ->
        {game, round}

      _ ->
        do_play_game(game, round + 1)
    end
  end

  def move_player(players, from, to) do
    {value, players} = Map.pop(players, from)
    Map.put(players, to, value)
  end

  def elf_count(game) do
    game.board
    |> Board.players(&(&1 == "E"))
    |> Enum.count()
  end

  def is_character?(c) do
    c in ["E", "G"]
  end

  def is_passable?(c) do
    c == "."
  end

  def enemy("E"), do: "G"
  def enemy("G"), do: "E"
end
