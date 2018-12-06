defmodule AOC.Day6Test do
  use ExUnit.Case, async: true
  alias AOC.Day6

  setup do
    {:ok,
     input: [
       {1, 1},
       {1, 6},
       {8, 3},
       {3, 4},
       {5, 5},
       {8, 9}
     ]}
  end

  test "owner", %{input: input} do
    assert Day6.owner(input, {1, 1}) == {1, 1}
    assert Day6.owner(input, {-1000, -1000}) == {1, 1}
    assert Day6.owner(input, {2, 3}) == {3, 4}
    assert Day6.owner(input, {1, 4}) == nil
  end

  test "square" do
    assert Day6.square({3, 4}, 0) == [{3, 4}]

    assert Day6.square({3, 4}, 1) == [
             {4, 3},
             {2, 3},
             {2, 5},
             {4, 4},
             {2, 4},
             {3, 5},
             {3, 3},
             {4, 5}
           ]
  end
end
