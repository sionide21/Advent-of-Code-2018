defmodule AOC.Day17 do
  defstruct [:map, :xrange, :yrange]

  def run(map) do
    new_map =
      map
      |> wet()
      |> dry()

    if map == new_map do
      wet(map)
    else
      run(new_map)
    end
  end

  def wet(map) do
    ymin.._ = map.yrange
    do_wet(map, {500, ymin})
  end

  def wet(map, square) do
    if in_bounds?(map, square) and !has_key?(map, square) do
      do_wet(map, square)
    else
      map
    end
  end

  def do_wet(map, {x, y} = square) do
    map
    |> type({x, y + 1})
    |> case do
      {:permeable, _} ->
        map
        |> put(square, {:permeable, {:wet, :down}})
        |> wet({x, y + 1})

      {:solid, _} ->
        map
        |> put(square, {:permeable, {:wet, :spread}})
        |> wet({x - 1, y})
        |> wet({x + 1, y})
    end
  end

  def dry(map) do
    transform(map, fn
      square, {:permeable, {:wet, :spread}} ->
        if water_stands?(map, square, &(&1 + 1)) and water_stands?(map, square, &(&1 - 1)) do
          {:solid, :water}
        else
          {:permeable, :dry}
        end

      _, {:permeable, {:wet, :down}} ->
        {:permeable, :dry}

      _, other ->
        other
    end)
  end

  defp transform(map, fun) do
    new_map =
      map.map
      |> Enum.map(fn {square, value} ->
        {square, fun.(square, value)}
      end)
      |> Map.new()

    %{map | map: new_map}
  end

  def water_stands?(map, {x, y}, next_fn) do
    map
    |> type({x, y})
    |> case do
      {:permeable, {:wet, :spread}} ->
        water_stands?(map, {next_fn.(x), y}, next_fn)

      {:solid, _} ->
        true

      _ ->
        false
    end
  end

  def count_wet(map) do
    map.map
    |> Enum.filter(fn {k, _} -> in_bounds?(map, k) end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.count(fn
      {:solid, :water} -> true
      {_, {:wet, _}} -> true
      _ -> false
    end)
  end

  def type(%{map: map}, square) do
    Map.get(map, square, {:permeable, :dry})
  end

  def has_key?(%{map: map}, square) do
    Map.has_key?(map, square) and Map.get(map, square) != {:permeable, :dry}
  end

  def put(map, square, type) do
    %{map | map: Map.put(map.map, square, type)}
  end

  def in_bounds?(map, {x, y}) do
    Enum.member?(map.xrange, x) and Enum.member?(map.yrange, y)
  end

  def parse(input) do
    map = parse_map(input)
    xmin..xmax = range(map, fn {x, _} -> x end)
    yrange = range(map, fn {_, y} -> y end)

    %__MODULE__{
      map: map,
      xrange: (xmin - 1)..(xmax + 1),
      yrange: yrange
    }
  end

  defp parse_map(input) do
    input
    |> Enum.map(fn line ->
      ~r/^(?<fixed>\w)=(?<value>\d+), (?<range>\w)=(?<start>\d+)\.\.(?<end>\d+)$/
      |> Regex.named_captures(line)
      |> Enum.map(fn {k, v} -> {String.to_atom(k), v} end)
      |> Enum.map(fn
        {k, v} when k in ~w[value start end]a ->
          {k, String.to_integer(v)}

        other ->
          other
      end)
      |> Map.new()
    end)
    |> Enum.reduce(%{}, fn line, map ->
      Enum.reduce(line.start..line.end, map, fn var, map ->
        square = parse_position(line.fixed, line.value, line.range, var)
        Map.put(map, square, {:solid, :clay})
      end)
    end)
  end

  defp parse_position("x", x, "y", y), do: {x, y}

  defp parse_position("y", y, "x", x), do: {x, y}

  defp range(map, fun) do
    {min, max} =
      map
      |> Map.keys()
      |> Enum.map(fun)
      |> Enum.min_max()

    min..max
  end

  defimpl String.Chars, for: __MODULE__ do
    def to_string(map) do
      Enum.map(map.yrange, fn y ->
        Enum.map(map.xrange, fn x ->
          map
          |> AOC.Day17.type({x, y})
          |> case do
            {_, :clay} -> "#"
            {_, :dry} -> "."
            {_, {:wet, _}} -> "|"
            {_, :water} -> "~"
          end
        end)
        |> Enum.join()
      end)
      |> Enum.join("\n")
    end
  end

  defimpl Inspect, for: __MODULE__ do
    def inspect(map, _opts) do
      "\n" <> to_string(map)
    end
  end
end
