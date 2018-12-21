defmodule AOC.Day20 do
  def parse("^" <> path) do
    path
    |> String.graphemes()
    |> do_parse(:start, %{}, [], [])
  end

  defp do_parse([d | rest], loc, graph, parent, froms) when d in ["N", "E", "S", "W"] do
    new_loc = move(loc, d)
    graph = Map.update(graph, loc, [new_loc], &[new_loc | &1])
    do_parse(rest, new_loc, graph, parent, froms)
  end

  defp do_parse(["(" | rest], loc, graph, parent, froms) do
    do_parse(rest, loc, graph, [loc | parent], [[] | froms])
  end

  defp do_parse(["|" | rest], loc, graph, [p | _] = parent, [f | froms]) do
    do_parse(rest, p, graph, parent, [[loc | f] | froms])
  end

  defp do_parse([")" | rest], loc, graph, [_ | parent], [f | froms]) do
    # Enum.reduce([loc | f], graph, fn child, graph ->
    #   do_parse(rest, child, graph, parent, froms)
    # end)
    do_parse(rest, loc, graph, parent, froms)
  end

  defp do_parse(["$"], _, graph, [], []) do
    graph
    |> Map.delete(:start)
    |> Enum.map(fn {k, v} -> {k, Enum.uniq(v)} end)
    |> Map.new()
  end

  defp move(:start, _), do: {0, 0}
  defp move({x, y}, "N"), do: {x, y + 1}
  defp move({x, y}, "S"), do: {x, y - 1}
  defp move({x, y}, "E"), do: {x + 1, y}
  defp move({x, y}, "W"), do: {x - 1, y}

  def furthest(graph) do
    graph
    |> bfs(%{}, fn {from, to}, acc ->
      path = [to | Map.get(acc, from, [])]
      Map.put(acc, to, path)
    end)
    |> Map.values()
    |> Enum.map(&length/1)
    |> Enum.max()
  end

  def count_1k(graph) do
    graph
    |> bfs(%{}, fn {from, to}, acc ->
      path = [to | Map.get(acc, from, [])]
      Map.put(acc, to, path)
    end)
    |> Map.values()
    |> Enum.map(&length/1)
    |> Enum.count(&(&1 >= 1000))
  end

  def bfs(graph, acc, fun) do
    queue = :queue.from_list([{:start, {0, 0}}])
    do_bfs(graph, queue, acc, fun)
  end

  def do_bfs(graph, queue, acc, fun) do
    queue
    |> :queue.out()
    |> case do
      {{:value, {from, to}}, queue} ->
        {children, graph} = Map.pop(graph, to, [])
        acc = fun.({from, to}, acc)
        queue = Enum.reduce(children, queue, fn child, queue ->
          :queue.in({to, child}, queue)
        end)
        do_bfs(graph, queue, acc, fun)

      {:empty, _} ->
        acc
    end
  end
end
