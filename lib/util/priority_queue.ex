defmodule Util.PriorityQueue do
  defstruct [:tree]

  defguard is_empty(pqueue) when pqueue == %__MODULE__{tree: {0, nil}}

  def new() do
    %__MODULE__{
      tree: :gb_trees.empty()
    }
  end

  def insert(pqueue, priority, value) do
    update(pqueue, priority, fn
      :empty -> :queue.from_list([value])
      queue -> :queue.in(value, queue)
    end)
  end

  def out(pqueue) when is_empty(pqueue) do
    {:empty, pqueue}
  end

  def out(pqueue) do
    {key, queue, tree} = :gb_trees.take_smallest(pqueue.tree)
    {{:value, value}, queue} = :queue.out(queue)

    tree =
      if :queue.is_empty(queue) do
        tree
      else
        :gb_trees.insert(key, queue, tree)
      end

    {{key, value}, %{pqueue | tree: tree}}
  end

  defp update(pqueue, key, fun) do
    tree =
      case :gb_trees.take_any(key, pqueue.tree) do
        :error ->
          :gb_trees.insert(key, fun.(:empty), pqueue.tree)

        {queue, tree} ->
          :gb_trees.insert(key, fun.(queue), tree)
      end

    %{pqueue | tree: tree}
  end
end
