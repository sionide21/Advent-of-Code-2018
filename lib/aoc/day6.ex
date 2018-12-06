defmodule AOC.Day6 do
  def largest_area(points) do
    points
    |> Enum.map(&area(points, &1))
    |> Enum.max()
  end

  def area(points, point) do
    do_area(points, point, MapSet.new(), 0, 0)
  end

  def do_area(points, point, seen, distance, total) do
    seen_count = MapSet.size(seen)

    point
    |> square(distance)
    |> Enum.reduce({0, seen}, fn spot, {count, seen} ->
      points
      |> owner(spot)
      |> case do
        nil ->
          {count, seen}

        ^point ->
          {count + 1, MapSet.put(seen, point)}

        other ->
          {count, MapSet.put(seen, other)}
      end
    end)
    |> case do
      {0, _} ->
        total

      {n, seen} ->
        if MapSet.size(seen) == seen_count && MapSet.size(seen) == Enum.count(points) do
          -1
        else
          do_area(points, point, seen, distance + 1, total + n)
        end
    end
  end

  def owner(points, coord) do
    {owner, _distance} =
      points
      |> Enum.map(&{&1, distance(&1, coord)})
      |> Enum.reduce(fn
        {point, distance}, {_, min} when distance < min ->
          {point, distance}

        {_, distance}, {_, min} when distance == min ->
          {nil, min}

        _, current ->
          current
      end)

    owner
  end

  def distance({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  def square({x, y}, distance) do
    Enum.flat_map(-distance..distance, fn d ->
      [
        {x + distance, y + d},
        {x - distance, y + d},
        {x + d, y + distance},
        {x + d, y - distance}
      ]
    end)
    |> Enum.uniq()
  end
end
