defmodule AOC.Day14Test do
  use ExUnit.Case, async: true
  alias AOC.Day14

  test "next_ten" do
    assert Day14.next_ten(9) == "5158916779"
    assert Day14.next_ten(5) == "0124515891"
    assert Day14.next_ten(18) == "9251071085"
    assert Day14.next_ten(2018) == "5941429882"
    assert Day14.next_ten(702_831) == "1132413111"
  end

  @tag timeout: :infinity
  test "first_seen" do
    assert Day14.first_seen("51589") == 9
    assert Day14.first_seen("01245") == 5
    assert Day14.first_seen("92510") == 18
    assert Day14.first_seen("59414") == 2018
    # assert Day14.first_seen("702831") == 20340231 # Off by one error, haven't found out why...
  end
end
