defmodule AOC.Day23.Bot do
  defstruct [:x, :y, :z, :r]

  def dist(bot1, bot2) do
    [:x, :y, :z]
    |> Enum.map(fn dim ->
      abs(Map.get(bot2, dim) - Map.get(bot1, dim))
    end)
    |> Enum.sum()
  end
end
