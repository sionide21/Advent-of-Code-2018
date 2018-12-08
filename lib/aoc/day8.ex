defmodule AOC.Day8 do
  def sum(list) do
    dfs(list, fn metadata, children ->
      Enum.sum(metadata ++ children)
    end)
  end

  def value(list) do
    dfs(list, fn
      metadata, [] ->
        Enum.sum(metadata)

      metadata, children ->
        Enum.reduce(metadata, 0, fn idx, acc ->
          acc + Enum.at(children, idx - 1, 0)
        end)
    end)
  end

  def dfs(list, fun) do
    {result, []} = do_dfs(list, fun)
    result
  end

  def do_dfs([0, num_meta | rest], fun) do
    apply(rest, fun, [], num_meta)
  end

  def do_dfs([num_children, num_meta | rest], fun) do
    {children, rest} =
      Enum.map_reduce(1..num_children, rest, fn _, rest ->
        do_dfs(rest, fun)
      end)

    apply(rest, fun, children, num_meta)
  end

  defp apply(rest, fun, children, num_meta) do
    {metadata, rest} = Enum.split(rest, num_meta)
    {fun.(metadata, children), rest}
  end
end
