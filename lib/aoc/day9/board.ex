defmodule AOC.Day9.Board do
  defstruct [:before, :after]

  def new() do
    %__MODULE__{
      before: [0],
      after: []
    }
  end

  def place(board, marble) do
    %{board | before: [marble | board.before]}
  end

  def pop(%{before: [marble | rest]} = board) do
    {marble, move(%{board | before: rest}, 1)}
  end

  def pop(%{before: []} = board) do
    board
    |> swap()
    |> pop()
  end

  def move(%{after: []} = board, motion) when motion > 0 do
    board
    |> swap()
    |> move(motion)
  end

  def move(%{after: [h | rest]} = board, motion) when motion > 0 do
    move(%{board | after: rest, before: [h | board.before]}, motion - 1)
  end

  def move(%{before: []} = board, motion) when motion < 0 do
    board
    |> swap()
    |> move(motion)
  end

  def move(%{before: [h | rest]} = board, motion) when motion < 0 do
    move(%{board | after: [h | board.after], before: rest}, motion + 1)
  end

  def move(board, 0) do
    board
  end

  defp swap(board) do
    %{board | before: Enum.reverse(board.after), after: Enum.reverse(board.before)}
  end

  defimpl Inspect, for: __MODULE__ do
    def inspect(%{before: b = [c | _], after: a}, _opts) do
      Kernel.inspect(%{list: Enum.reverse(b) ++ a, current: c})
    end
  end
end
