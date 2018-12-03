defmodule AOC.Day3 do
  defstruct [:id, :x, :y, :w, :h]

  def parse(claim) do
    [id, x, y, w, h] =
      Regex.run(~r/^#(\d+) @ (\d+),(\d+): (\d+)x(\d+)$/, claim, capture: :all_but_first)
      |> Enum.map(&String.to_integer/1)

    %__MODULE__{id: id, x: x, y: y, w: w, h: h}
  end

  def fill(%{x: x, y: y, w: w, h: h}) do
    Enum.flat_map(x..(x + w - 1), fn x ->
      Enum.map(y..(y + h - 1), fn y ->
        {x, y}
      end)
    end)
  end

  def build_map(claims, fun) do
    Enum.reduce(claims, %{}, fn claim, fabric ->
      AOC.Day3.fill(claim)
      |> Enum.reduce(fabric, fn coord, fabric ->
        fun.(fabric, claim, coord)
      end)
    end)
  end
end
