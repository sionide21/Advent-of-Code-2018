defmodule AOC.Day13 do
  alias __MODULE__.{Board, Cart}

  def parse_board(input) do
    Board.parse(input)
  end

  def first_crash(board) do
    board
    |> Board.carts()
    |> Enum.reduce_while({:more, board}, fn cart, {:more, board} ->
      next = Cart.next(cart)

      if Board.has_cart?(board, next) do
        {:halt, {:done, next}}
      else
        {:cont, {:more, Board.move(board, cart)}}
      end
    end)
    |> case do
      {:done, coord} -> coord
      {:more, board} -> first_crash(board)
    end
  end

  def last_cart(board, day \\ 0) do
    board =
      board
      |> Board.carts()
      |> Enum.reduce(board, fn cart, board ->
        next = Cart.next(cart)

        cond do
          !Board.has_cart?(board, cart.coord) ->
            board

          Board.has_cart?(board, next) ->
            board
            |> Board.remove_cart(next)
            |> Board.remove_cart(cart.coord)

          true ->
            Board.move(board, cart)
        end
      end)

    case Board.carts(board) do
      [cart] ->
        cart.coord

      _ ->
        last_cart(board, day + 1)
    end
  end

  def output_coords({x, y}) do
    "#{x},#{y}"
  end
end
