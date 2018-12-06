defmodule AOC.Day6 do
  def largest_area(points) do
    points
    |> areas()
    |> Map.values()
    |> Enum.max()
  end

  def areas(points) do
    center = center(points)
    do_areas(points, center, %{}, 0, false)
  end

  def do_areas(points, point, areas, distance, done?) do
    new_areas =
      point
      |> square(distance)
      |> Enum.reduce(areas, fn spot, areas ->
        points
        |> owner(spot)
        |> case do
          nil ->
            areas

          owner ->
            Map.update(areas, owner, 1, &(&1 + 1))
        end
      end)

    cond do
      done? ->
        areas
        |> Enum.filter(fn {owner, area} -> new_areas[owner] == area end)
        |> Enum.into(%{})

      Enum.count(new_areas) == Enum.count(points) ->
        do_areas(points, point, new_areas, distance + 1, true)

      true ->
        do_areas(points, point, new_areas, distance + 1, false)
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

  def center(points) do
    size = Enum.count(points)

    {sumx, sumy} =
      points
      |> Enum.reduce(fn {x, y}, {sumx, sumy} ->
        {x + sumx, y + sumy}
      end)

    {round(sumx / size), round(sumy / size)}
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
