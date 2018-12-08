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
        Enum.reduce(children, acc, fn child, acc ->
          Map.update(acc, child, [node], &[node | &1])
        end)
    end)
  end

  def process(graph, workers, base_time) do
    dependencies = dependencies(graph)
    workers = Enum.map(1..workers, fn _ -> nil end)
    IO.puts("")
    do_process(dependencies, workers, base_time, 0, [], [])
  end

  defp do_process(_, _, _, time, seen, done) when time > 0 and length(seen) == length(done) do
    time - 1
  end

  defp do_process(dependencies, workers, base_time, time, seen, done) do
    {workers, done} =
      Enum.map_reduce(workers, done, fn worker, done ->
        case worker({:tick, time}, worker) do
          {:done, task, w} ->
            {w, [task | done]}

          _ ->
            {worker, done}
        end
      end)

    {workers, seen} =
      Enum.map_reduce(workers, seen, fn worker, seen ->
        case worker({:tick, time}, worker) do
          {:needs_work, w} ->
            assign_work(w, dependencies, seen, done, base_time, time)

          _ ->
            {worker, seen}
        end
      end)

    inspect_step(workers, seen, done, dependencies, time)
    do_process(dependencies, workers, base_time, time + 1, seen, done)
  end

  def inspect_step(workers, seen, done, dependencies, time) do
    workers =
      Enum.map(workers, fn
        {task, _} -> task
        nil -> "."
      end)
      |> Enum.map(&String.pad_trailing(&1, 2))
      |> Enum.join()

    available = available(dependencies, seen, done) |> Enum.join()
    done = done |> Enum.join() |> String.pad_trailing(Enum.count(dependencies) + 1)

    IO.puts([String.pad_trailing(to_string(time), 4), workers, done, available])
  end

  def assign_work(worker, dependencies, seen, done, base_time, time) do
    next(dependencies, seen, done)
    |> case do
      nil ->
        {worker, seen}

      task = <<ord::integer>> ->
        finish_at = ord - 64 + time + base_time
        {worker({:assign, task, finish_at}, worker), [task | seen]}
    end
  end

  def worker({:tick, _time}, nil) do
    {:needs_work, nil}
  end

  def worker({:tick, time}, {task, finish}) when time < finish do
    {:working, {task, finish}}
  end

  def worker({:tick, time}, {task, time}) do
    {:done, task, nil}
  end

  def worker({:assign, task, time}, nil) do
    {task, time}
  end

  def available(dependencies, seen, done) do
    dependencies
    |> Enum.flat_map(fn {k, v} -> if(v -- done == [], do: [k], else: []) end)
    |> Kernel.--(seen)
    |> Kernel.--(done)
    |> Enum.sort()
  end

  def next(dependencies, seen, done) do
    available(dependencies, seen, done)
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

  def push(list, :start) do
    list
  end

  def push(list, value) do
    [value | list]
  end
end
