defmodule AOC.Day13.Board do
  alias AOC.Day13.Cart
  defstruct [:width, :height, rails: %{}, carts: %{}]

  def carts(%{carts: carts}) do
    carts
    |> Map.values()
    |> Enum.sort_by(fn %Cart{coord: {x, y}} -> {y, x} end)
  end

  def parse(input) do
    {board, _} =
      input
      |> String.graphemes()
      |> Enum.reduce({%__MODULE__{}, {0, 0}}, fn
        " ", {board, {x, y}} ->
          {board, {x + 1, y}}

        "\n", {board, {_x, y}} ->
          {board, {0, y + 1}}

        piece, {board, {x, y}} ->
          {process_piece(board, {x, y}, piece), {x + 1, y}}
      end)

    add_dimensions(board)
  end

  def move(board, cart) do
    coord = Cart.next(cart)
    rail = Map.fetch!(board.rails, coord)

    carts =
      board.carts
      |> Map.delete(cart.coord)
      |> Map.put(coord, Cart.move(cart, rail))

    %{board | carts: carts}
  end

  def has_cart?(%{carts: carts}, coord) do
    Map.has_key?(carts, coord)
  end

  def remove_cart(board, coord) do
    %{board | carts: Map.delete(board.carts, coord)}
  end

  defp process_piece(board, coord, rail) when rail in ["|", "/", "-", "\\", "+"] do
    add_rail(board, coord, rail)
  end

  defp process_piece(board, coord, cart) when cart in ["^", "v"] do
    board
    |> add_cart(coord, cart)
    |> add_rail(coord, "|")
  end

  defp process_piece(board, coord, cart) when cart in ["<", ">"] do
    board
    |> add_cart(coord, cart)
    |> add_rail(coord, "-")
  end

  defp add_cart(board, coord, direction) do
    cart = %Cart{coord: coord, direction: direction}
    %{board | carts: Map.put(board.carts, coord, cart)}
  end

  defp add_rail(board, coord, rail) do
    %{board | rails: Map.put(board.rails, coord, rail)}
  end

  defp add_dimensions(board) do
    {width, height} =
      board.rails
      |> Map.keys()
      |> Enum.max()

    %{board | width: width + 1, height: height + 1}
  end

  defimpl Inspect, for: __MODULE__ do
    def inspect(board, _opts) do
      Enum.map(0..(board.height - 1), fn y ->
        Enum.map(0..(board.width - 1), fn x ->
          if AOC.Day13.Board.has_cart?(board, {x, y}) do
            Map.get(board.carts, {x, y}).direction
          else
            Map.get(board.rails, {x, y}, " ")
          end
        end)
        |> Enum.join()
      end)
      |> Enum.join("\n")
    end
  end
end
