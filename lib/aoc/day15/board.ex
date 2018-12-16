defmodule AOC.Day15.Board do
  defstruct [:positions]

  def parse(input) do
    input
    |> String.graphemes()
    |> Enum.reduce({%{}, {0, 0}}, fn
      "\n", {board, {y, _x}} ->
        {board, {y + 1, 0}}

      square, {board, {y, x}} ->
        {Map.put(board, {y, x}, square), {y, x + 1}}
    end)
    |> case do
      {positions, _} ->
        %__MODULE__{positions: positions}
    end
  end

  def players(%{positions: positions}, character?) do
    positions
    |> Enum.sort()
    |> Enum.filter(fn {_coord, v} ->
      character?.(v)
    end)
  end

  def current?(%{positions: positions}, {coord, value}) do
    Map.get(positions, coord) == value
  end

  def move(board = %{positions: positions}, from, to) do
    {value, positions} = Map.get_and_update!(positions, from, &{&1, "."})
    %{board | positions: Map.replace!(positions, to, value)}
  end

  def remove(board = %{positions: positions}, from) do
    %{board | positions: Map.put(positions, from, ".")}
  end

  def shortest_path(board, passable?, start, target_type) do
    visitable? = &(passable?.(&1) or &1 == target_type)

    board
    |> bfs(visitable?, start, %{}, fn {coord, el, from}, acc ->
      path = [coord | Map.get(acc, from, [])]

      if el == target_type do
        {:halt, {:ok, Enum.reverse(path)}}
      else
        {:cont, Map.put(acc, coord, path)}
      end
    end)
    |> case do
      {:ok, path} ->
        {:ok, path}

      _ ->
        :error
    end
  end

  def bfs(%{positions: positions}, visitable?, initial, acc, fun) do
    queue = :queue.new()
    positions = Map.delete(positions, initial)
    visit_neighbors(positions, visitable?, queue, initial, acc, fun)
  end

  def do_bfs(positions, visitable?, queue, acc, fun) do
    queue
    |> :queue.out()
    |> case do
      {{:value, {coord, data, from}}, queue} ->
        fun.({coord, data, from}, acc)
        |> case do
          {:cont, acc} ->
            visit_neighbors(positions, visitable?, queue, coord, acc, fun)

          {:halt, acc} ->
            acc
        end

      {:empty, _} ->
        acc
    end
  end

  def neighbors(%{positions: positions}, {y, x}, type) do
    [{y - 1, x}, {y, x - 1}, {y, x + 1}, {y + 1, x}]
    |> Enum.filter(&(Map.get(positions, &1, nil) == type))
  end

  defp visit_neighbors(positions, visitable?, queue, {y, x}, acc, fun) do
    {positions, queue} =
      [{y - 1, x}, {y, x - 1}, {y, x + 1}, {y + 1, x}]
      |> Enum.reduce({positions, queue}, fn coord, {positions, queue} ->
        positions
        |> Map.pop(coord)
        |> case do
          {nil, _} ->
            {positions, queue}

          {value, positions} ->
            if visitable?.(value) do
              {positions, :queue.in({coord, value, {y, x}}, queue)}
            else
              {positions, queue}
            end
        end
      end)

    do_bfs(positions, visitable?, queue, acc, fun)
  end

  defimpl String.Chars, for: __MODULE__ do
    def to_string(%{positions: positions}) do
      positions
      |> Enum.sort()
      |> Enum.chunk_by(fn {{y, _x}, _v} -> y end)
      |> Enum.map(fn row -> Enum.map(row, &elem(&1, 1)) end)
      |> Enum.join("\n")
    end
  end

  defimpl Inspect, for: __MODULE__ do
    def inspect(board, _opts) do
      to_string(board)
    end
  end
end
