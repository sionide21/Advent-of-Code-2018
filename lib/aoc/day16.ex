defmodule AOC.Day16 do
  @opcodes %{
    0 => :eqir,
    1 => :seti,
    2 => :eqri,
    3 => :eqrr,
    4 => :addi,
    5 => :setr,
    6 => :gtrr,
    7 => :gtri,
    8 => :muli,
    9 => :bori,
    10 => :bani,
    11 => :borr,
    12 => :gtir,
    13 => :banr,
    14 => :addr,
    15 => :mulr
  }

  def parse_part1(input) do
    input
    |> Enum.chunk_every(4)
    |> Enum.filter(&match?(["Before: " <> _ | _], &1))
    |> Enum.map(fn ["Before: [" <> input, op, "After:  [" <> output, ""] ->
      [parse_registers(input), parse_op(op), parse_registers(output)]
    end)
  end

  def parse_part2(input) do
    input
    |> Enum.map(&parse_op/1)
  end

  defp parse_registers(registers) do
    registers
    |> String.trim("]")
    |> String.split(", ")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  def parse_op(op) do
    op
    |> String.split(" ")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  def possible_ops(input, operands, output) do
    [
      :addr,
      :addi,
      :mulr,
      :muli,
      :banr,
      :bani,
      :borr,
      :bori,
      :setr,
      :seti,
      :gtir,
      :gtri,
      :gtrr,
      :eqir,
      :eqri,
      :eqrr
    ]
    |> Enum.filter(fn op ->
      op(op, operands, input) == output
    end)
  end

  def op({code, a, b, c}, registers) do
    Map.fetch!(@opcodes, code)
    |> op({a, b, c}, registers)
  end

  def op(:addr, operands, registers) do
    update_r(registers, operands, &+/2)
  end

  def op(:addi, operands, registers) do
    update_i(registers, operands, &+/2)
  end

  def op(:mulr, operands, registers) do
    update_r(registers, operands, &*/2)
  end

  def op(:muli, operands, registers) do
    update_i(registers, operands, &*/2)
  end

  def op(:banr, operands, registers) do
    update_r(registers, operands, &:erlang.band/2)
  end

  def op(:bani, operands, registers) do
    update_i(registers, operands, &:erlang.band/2)
  end

  def op(:borr, operands, registers) do
    update_r(registers, operands, &:erlang.bor/2)
  end

  def op(:bori, operands, registers) do
    update_i(registers, operands, &:erlang.bor/2)
  end

  def op(:setr, operands, registers) do
    update_r(registers, operands, fn a, _b -> a end)
  end

  def op(:seti, {a, _b, c}, registers) do
    store(a, registers, c)
  end

  def op(:gtir, {a, b, c}, registers) do
    update_i(registers, {b, a, c}, fn b, a -> bool(a > b) end)
  end

  def op(:gtri, operands, registers) do
    update_i(registers, operands, fn a, b -> bool(a > b) end)
  end

  def op(:gtrr, operands, registers) do
    update_r(registers, operands, fn a, b -> bool(a > b) end)
  end

  def op(:eqir, {a, b, c}, registers) do
    update_i(registers, {b, a, c}, fn b, a -> bool(a == b) end)
  end

  def op(:eqri, operands, registers) do
    update_i(registers, operands, fn a, b -> bool(a == b) end)
  end

  def op(:eqrr, operands, registers) do
    update_r(registers, operands, fn a, b -> bool(a == b) end)
  end

  def op(:fact, operands, registers) do
    update_r(registers, operands, fn a, _b ->
      Enum.filter(1..a, &(rem(a, &1) == 0)) |> Enum.sum()
    end)
  end

  def update_r(registers, {a, b, c}, fun) do
    b = read(registers, b)
    update_i(registers, {a, b, c}, fun)
  end

  def update_i(registers, {a, b, c}, fun) do
    a = read(registers, a)

    fun.(a, b)
    |> store(registers, c)
  end

  def store(value, registers, register) do
    put_elem(registers, register, value)
  end

  def read(registers, register) do
    elem(registers, register)
  end

  def bool(true), do: 1
  def bool(false), do: 0
end
