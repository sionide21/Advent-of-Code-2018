defmodule AOC.Day13.Cart do
  defstruct [:coord, :direction, next_turn: :left]

  def move(cart, next) do
    %{cart | coord: next_coord(cart.coord, cart.direction)}
    |> orient(next)
  end

  def next(%{direction: direction, coord: coord}) do
    next_coord(coord, direction)
  end

  defp next_coord({x, y}, "^") do
    {x, y - 1}
  end

  defp next_coord({x, y}, "v") do
    {x, y + 1}
  end

  defp next_coord({x, y}, ">") do
    {x + 1, y}
  end

  defp next_coord({x, y}, "<") do
    {x - 1, y}
  end

  defp orient(cart, "+") do
    %{
      cart
      | next_turn: next_turn(cart.next_turn),
        direction: turn(cart.next_turn, cart.direction)
    }
  end

  defp orient(cart, curve) when curve in ["\\", "/"] do
    %{cart | direction: curve(cart.direction, curve)}
  end

  defp orient(cart, _) do
    cart
  end

  defp next_turn(:left), do: :straight
  defp next_turn(:straight), do: :right
  defp next_turn(:right), do: :left

  defp turn(:left, "<"), do: "v"
  defp turn(:left, "v"), do: ">"
  defp turn(:left, ">"), do: "^"
  defp turn(:left, "^"), do: "<"
  defp turn(:right, ">"), do: "v"
  defp turn(:right, "v"), do: "<"
  defp turn(:right, "<"), do: "^"
  defp turn(:right, "^"), do: ">"
  defp turn(:straight, x), do: x

  defp curve("^", "/"), do: ">"
  defp curve("^", "\\"), do: "<"
  defp curve("<", "/"), do: "v"
  defp curve("<", "\\"), do: "^"
  defp curve(">", "/"), do: "^"
  defp curve(">", "\\"), do: "v"
  defp curve("v", "/"), do: "<"
  defp curve("v", "\\"), do: ">"
end
