defmodule AOC.Day11 do
  def power({x, y}, serial) do
    rack = x + 10

    rack
    |> Kernel.*(y)
    |> Kernel.+(serial)
    |> Kernel.*(rack)
    |> rem(1000)
    |> div(100)
    |> Kernel.-(5)
  end

  def grid(width, height, serial) do
    reduce(width, height, %{}, fn {x, y}, grid ->
      Map.put(grid, {x, y}, power({x, y}, serial))
    end)
  end

  def reduce(width, height, acc, fun) do
    Enum.reduce(1..width, acc, fn x, acc ->
      Enum.reduce(1..height, acc, fn y, acc ->
        fun.({x, y}, acc)
      end)
    end)
  end

  def total_power(cell, d, powers) do
    Enum.reduce(0..(d-1), 0, fn d, acc ->
      power(cell, d, acc, powers)
    end)
  end
  # def total_power({x, y}, w, h, powers) do
  #   reduce(w, h, 0, fn {dx, dy}, acc ->
  #     powers[{x + dx - 1, y + dy - 1}] + acc
  #   end)
  # end

  def best(serial) do
    powers = grid(300, 300, serial)
    reduce(297, 297, {nil, 0}, fn cell, {max_pos, max_power} ->
      cell
      |> total_power(3, powers)
      |> case do
        p when p > max_power -> {cell, p}
        _ -> {max_pos, max_power}
      end
    end)
  end

  def power(cell, 0, acc, powers) do
    acc + powers[cell]
  end
  def power({x, y}, d, acc, powers) do
    acc = reduce_times(d, acc, fn dx, acc ->
      powers[{x + dx - 1, y + d}] + acc
    end)
    acc = reduce_times(d, acc, fn dy, acc ->
      powers[{x + d, y + dy - 1}] + acc
    end)
    acc + powers[{x + d, y + d}]
  end

  def reduce_times(0, acc, _fun) do
    acc
  end
  def reduce_times(times, acc, fun) do
    Enum.reduce(1..times, acc, fun)
  end

  def best_ever(serial) do
    import Benchmark
    powers = measure(grid(300, 300, serial))
    reduce_times(299, {powers, nil, 0, 0}, fn size, {grid, max_pos, max_power, max_size} ->
      grid = power_up(grid, size, powers)
      reduce(300 - size, 300 - size, {grid, max_pos, max_power, max_size}, fn cell, acc={grid, _, max_power, _} ->
        case grid[cell] do
          p when p > max_power -> {grid, cell, p, size}
          _ -> acc
        end
      end)
    end)
    |> case do
      {_, max_pos, max_power, max_size} ->
        {max_pos, max_size + 1, max_power}
    end
  end

  def power_up(grid, level, powers) do
    reduce(300-level, 300-level, grid, fn cell, grid ->
      Map.update!(grid, cell, &power(cell, level, &1, powers))
    end)
  end
end
