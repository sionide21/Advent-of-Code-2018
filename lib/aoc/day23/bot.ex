defmodule AOC.Day23.Bot do
  defstruct [:x, :y, :z, :r]

  def dist(bot1, bot2) do
    [:x, :y, :z]
    |> Enum.map(fn dim ->
      abs(Map.get(bot2, dim) - Map.get(bot1, dim))
    end)
    |> Enum.sum()
  end

  def cubify(bot) do
    [:x, :y, :z]
    |> Enum.map(fn dim ->
      center = Map.get(bot, dim)
      {center - bot.r, center + bot.r}
    end)
    |> List.to_tuple()
  end

  def cover?(bot, {x, y, z}) do
    dist(bot, %{x: x, y: y, z: z}) <= bot.r
  end

  def overlap?(bot1, bot2) do
    dist(bot1, bot2) < bot1.r + bot2.r
  end
end
