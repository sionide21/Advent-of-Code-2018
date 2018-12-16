defmodule AOC.Day13.CartTest do
  use ExUnit.Case, async: true
  alias AOC.Day13.Cart

  test "move" do
    assert Cart.move(%Cart{coord: {0, 0}, direction: ">"}, "-") == %Cart{
             coord: {1, 0},
             direction: ">"
           }

    assert Cart.move(%Cart{coord: {1, 0}, direction: "<"}, "-") == %Cart{
             coord: {0, 0},
             direction: "<"
           }

    assert Cart.move(%Cart{coord: {0, 0}, direction: "v"}, "|") == %Cart{
             coord: {0, 1},
             direction: "v"
           }

    assert Cart.move(%Cart{coord: {0, 1}, direction: "^"}, "|") == %Cart{
             coord: {0, 0},
             direction: "^"
           }

    assert Cart.move(%Cart{coord: {0, 1}, direction: "^", next_turn: :left}, "+") == %Cart{
             coord: {0, 0},
             direction: "<",
             next_turn: :straight
           }

    assert Cart.move(%Cart{coord: {0, 1}, direction: "^", next_turn: :straight}, "+") == %Cart{
             coord: {0, 0},
             direction: "^",
             next_turn: :right
           }

    assert Cart.move(%Cart{coord: {0, 1}, direction: "^", next_turn: :right}, "+") == %Cart{
             coord: {0, 0},
             direction: ">",
             next_turn: :left
           }

    assert Cart.move(%Cart{coord: {0, 0}, direction: ">"}, "\\") == %Cart{
             coord: {1, 0},
             direction: "v"
           }

    assert Cart.move(%Cart{coord: {0, 1}, direction: "^"}, "\\") == %Cart{
             coord: {0, 0},
             direction: "<"
           }

    assert Cart.move(%Cart{coord: {0, 1}, direction: "^"}, "/") == %Cart{
             coord: {0, 0},
             direction: ">"
           }

    assert Cart.move(%Cart{coord: {1, 0}, direction: "<"}, "/") == %Cart{
             coord: {0, 0},
             direction: "v"
           }
  end

  test "next" do
    assert Cart.next(%Cart{coord: {0, 0}, direction: ">"}) == {1, 0}
    assert Cart.next(%Cart{coord: {0, 0}, direction: "<"}) == {-1, 0}
    assert Cart.next(%Cart{coord: {0, 0}, direction: "v"}) == {0, 1}
    assert Cart.next(%Cart{coord: {0, 0}, direction: "^"}) == {0, -1}
  end
end
