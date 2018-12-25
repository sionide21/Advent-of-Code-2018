defmodule AOC.Day22 do
  alias Util.PriorityQueue

  defstruct [:depth, :target, erosions: %{}]

  def parse(input) do
    ["depth:", depth, "target:", target] =
      input
      |> Enum.join("\n")
      |> String.split()

    target =
      target
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()

    %__MODULE__{
      depth: String.to_integer(depth),
      target: target
    }
  end

  def risk(map) do
    {tx, ty} = map.target

    Enum.reduce(0..tx, {map, 0}, fn x, acc ->
      Enum.reduce(0..ty, acc, fn y, {map, sum} ->
        {map, type} = type(map, {x, y})
        {map, sum + type}
      end)
    end)
  end

  def index(map, {0, 0}) do
    {map, 0}
  end

  def index(%{target: coord} = map, coord) do
    {map, 0}
  end

  def index(map, {x, 0}) do
    {map, x * 16807}
  end

  def index(map, {0, y}) do
    {map, y * 48271}
  end

  def index(map, {x, y}) do
    {map, left} = erosion(map, {x - 1, y})
    {map, up} = erosion(map, {x, y - 1})

    {map, left * up}
  end

  def erosion(map, coord) do
    if Map.has_key?(map.erosions, coord) do
      {map, Map.get(map.erosions, coord)}
    else
      {map, index} = index(map, coord)
      erosion = rem(index + map.depth, 20183)
      map = %{map | erosions: Map.put(map.erosions, coord, erosion)}
      {map, erosion}
    end
  end

  def type(map, coord) do
    {map, erosion} = erosion(map, coord)
    {map, rem(erosion, 3)}
  end

  def shortest_path(map) do
    target = {:torch, map.target}

    djikstra(map, %{}, fn {cost, {from, to}}, acc ->
      cost = cost + Map.get(acc, from, 0)

      if to == target do
        {:halt, cost}
      else
        {:cont, Map.put(acc, to, cost)}
      end
    end)
  end

  def djikstra(map, acc, fun) do
    queue =
      PriorityQueue.new()
      |> PriorityQueue.insert(0, {0, :start, {:torch, {0, 0}}})

    do_djikstra(map, queue, MapSet.new(), acc, fun)
  end

  def do_djikstra(map, queue, seen, acc, fun) do
    queue
    |> PriorityQueue.out()
    |> case do
      {{_, {cost, from, to}}, queue} ->
        if MapSet.member?(seen, to) do
          do_djikstra(map, queue, seen, acc, fun)
        else
          seen = MapSet.put(seen, to)

          fun.({cost, {from, to}}, acc)
          |> case do
            {:cont, acc} ->
              {map, queue} = add_neighbors(map, queue, cost, to)
              {map, queue} = switch_tools(map, queue, cost, to)
              do_djikstra(map, queue, seen, acc, fun)

            {:halt, acc} ->
              acc
          end
        end

      {:empty, _} ->
        acc
    end
  end

  def add_neighbors(map, queue, cost, {current_tool, {x, y}}) do
    [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}]
    |> Enum.filter(fn {x, y} -> x >= 0 and y >= 0 end)
    |> Enum.reduce({map, queue}, fn neighbor, {map, queue} ->
      {map, tools} = possible_tools(map, neighbor)

      queue =
        if current_tool in tools do
          enqueue(map, queue, cost + 1, {x, y}, {current_tool, neighbor})
        else
          queue
        end

      {map, queue}
    end)
  end

  def switch_tools(map, queue, cost, {current_tool, coord}) do
    {map, tools} = possible_tools(map, coord)

    queue =
      Enum.reduce(tools -- [current_tool], queue, fn tool, queue ->
        enqueue(map, queue, cost + 7, coord, {tool, coord})
      end)

    {map, queue}
  end

  def enqueue(map, queue, cost, from, to) do
    PriorityQueue.insert(queue, cost + hueristic(map, to), {cost, from, to})
  end

  def possible_tools(map, coord) do
    {map, type} = type(map, coord)

    tools =
      case type do
        0 -> [:climbing, :torch]
        1 -> [:climbing, :neither]
        2 -> [:torch, :neither]
      end

    {map, tools}
  end

  def hueristic(map, {current_tool, {x, y}}) do
    {tx, ty} = map.target
    abs(tx - x) + abs(ty - y) + if(current_tool == :torch, do: 0, else: 7)
  end
end
