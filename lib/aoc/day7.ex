defmodule AOC.Day7 do
  def build_graph(input) do
    input
    |> Enum.map(&Regex.run(~r/(\w+) must .+ step (\w+)/, &1))
    |> Enum.reduce(%{}, fn [_, prereq, step], acc ->
      Map.update(acc, prereq, [step], &[step | &1])
    end)
    |> add_start_node()
  end

  defp add_start_node(graph) do
    Map.put(graph, :start, Map.keys(graph))
  end

  def dependencies(graph) do
    graph
    |> Enum.reduce(%{}, fn
      {:start, children}, acc ->
        Enum.reduce(children, acc, fn child, acc -> Map.put_new(acc, child, []) end)
      {node, children}, acc ->
        Enum.reduce(children, acc, fn child, acc -> Map.update(acc, child, [node], &[node | &1]) end)
    end)
  end

  def process(graph, workers, base_time) do
    dependencies = dependencies(graph)
    workers = Enum.map(1..workers, fn _ -> nil end)

    do_process(dependencies, workers, base_time, 1, [], [])
  end

  defp do_process(dependencies, workers, base_time, time, seen, done) do
    {workers, seen, done} =
      Enum.reduce(workers, {, seen, done}, fn workers, seen, done -> )

  end

  def worker({:tick, time}, nil) do
    {:needs_work, nil}
  end
  def worker({:tick, time}, {task, finish}) when time < finish do
    {:working, {task, finish}}
  end
  def worker({:tick, time}, {task, time}) do
    {:done, task, nil}
  end
  def worker({:assign, task, time}, nil) do
    {:working, {task, time}}
  end

  def next(dependencies, seen \\ [], done \\ []) do
    dependencies
    |> Enum.flat_map(fn {k, v} -> if(v -- done == [], do: [k], else: []) end)
    |> Kernel.--(seen)
    |> Kernel.--(done)
    |> Enum.at(0)
  end

  def flatten(graph, node \\ :start, acc \\ []) do
    cond do
      Enum.member?(acc, node) ->
        acc

      true ->
        graph
        |> Map.get(node, [])
        |> Enum.sort()
        |> Enum.reverse()
        |> Enum.reduce(acc, fn child, acc ->
          flatten(graph, child, acc)
        end)
        |> push(node)
    end
  end

  def pop(graph, done) do

  end

  def push(list, :start) do
    list
  end

  def push(list, value) do
    [value | list]
  end
end
