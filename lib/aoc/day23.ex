defmodule AOC.Day23 do
  alias __MODULE__.Bot

  def parse(input) do
    input
    |> Enum.map(fn line ->
      ~r/^pos=<(?<x>-?\d+),(?<y>-?\d+),(?<z>-?\d+)>, r=(?<r>\d+)$/
      |> Regex.run(line, capture: :all_but_first)
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.map(fn [x, y, z, r] ->
      %Bot{x: x, y: y, z: z, r: r}
    end)
  end

  def coverage(bots, point) do
    Enum.count(bots, &Bot.cover?(&1, point))
  end

  def filter_points(bots, {{sx, ex}, {sy, ey}, {sz, ez}}, expected) do
    Enum.flat_map(sx..ex, fn x ->
      Enum.flat_map(sy..ey, fn y ->
        Enum.flat_map(sz..ez, fn z ->
          if coverage(bots, {x, y, z}) == expected do
            [{x, y, z}]
          else
            []
          end
        end)
      end)
    end)
  end

  def best_point(bots, {{sx, ex}, {sy, ey}, {sz, ez}}) do
    Enum.flat_map(sx..ex, fn x ->
      Enum.flat_map(sy..ey, fn y ->
        Enum.map(sz..ez, fn z ->
          {x, y, z}
        end)
      end)
    end)
    |> Enum.max_by(fn point ->
      {coverage(bots, point), -1 * away(point)}
    end)
  end

  defp away({x, y, z}) do
    abs(x) + abs(y) + abs(z)
  end

  def cubes(bots) do
    Enum.map(bots, &Bot.cubify/1)
  end

  def best_region(bots) do
    cubes = cubes(bots)
    cubes
    |> bounds()
    |> do_best_region(cubes, [], %{})
  end

  defp memoize(memo, key, fun) do
    if Map.has_key?(memo, key) do
      {memo, Map.get(memo, key)}
    else
      {memo, value} = fun.()
      {Map.put(memo, key, value), value}
    end
  end

  defp do_best_region(common, [cube | rest], bots, memo) do
    common
    |> intersect(cube)
    |> case do
      :empty ->
        memoize(memo, bots, fn -> do_best_region(common, rest, bots, memo) end)

      with_me ->
        new_bots = Enum.sort([with_me | bots])
        {memo, {region1, coverage1}} = memoize(memo, new_bots, fn -> do_best_region(with_me, rest, new_bots, memo) end)
        {memo, {region2, coverage2}} = memoize(memo, bots, fn -> do_best_region(common, rest, bots, memo) end)

        if coverage1 > coverage2 do
          {memo, {region1, coverage1}}
        else
          {memo, {region2, coverage2}}
        end
    end
  end

  defp do_best_region(region, [], bots, memo) do
    # IO.inspect({region, length(bots)}, label: inspect(bots))
    {memo, {region, length(bots)}}
  end

  defp bounds(cubes) do
    Enum.reduce(cubes, fn {x1, y1, z1}, {x2, y2, z2} ->
      {union(x1, x2), union(y1, y2), union(z1, z2)}
    end)
  end

  defp union({s1, e1}, {s2, e2}) do
    s = min(s1, s2)
    e = max(e1, e2)
    {s, e}
  end

  def intersect({x1, y1, z1}, {x2, y2, z2}) do
    with {:ok, x} <- overlapping_interval(x1, x2),
         {:ok, y} <- overlapping_interval(y1, y2),
         {:ok, z} <- overlapping_interval(z1, z2)
    do
      {x, y, z}
    else
      :empty -> :empty
    end
  end

  defp overlapping_interval({s1, e1}, {s2, e2}) do
    s = max(s1, s2)
    e = min(e1, e2)

    if s < e do
      {:ok, {s, e}}
    else
      :empty
    end
  end

  def centerpoint(bots) do
    bots
    |> Enum.reduce([0, 0, 0], fn %{x: x, y: y, z: z}, [tx, ty, tz] ->
      [x + tx, y + ty, z + tz]
    end)
    |> Enum.map(&div(&1, length(bots)))
    |> List.to_tuple()
  end
end
