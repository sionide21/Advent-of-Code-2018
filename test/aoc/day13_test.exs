defmodule AOC.Day13Test do
  use ExUnit.Case, async: true
  alias AOC.Day13

  test "first crash" do
    input = """
    /->-\\
    |   |  /----\\
    | /-+--+-\\  |
    | | |  | v  |
    \\-+-/  \\-+--/
      \\------/
    """

    coord =
      input
      |> Day13.parse_board()
      |> Day13.first_crash()

    assert coord == {7, 3}
  end

  test "last crash" do
    input = """
    />-<\\
    |   |
    | /<+-\\
    | | | v
    \\>+</ |
      |   ^
      \\<->/
    """

    coord =
      input
      |> Day13.parse_board()
      |> Day13.last_cart()

    assert coord == {6, 4}
  end
end
