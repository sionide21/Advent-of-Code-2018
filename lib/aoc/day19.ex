defmodule AOC.Day19 do
  defstruct [:ipr, :registers, :ops]

  def parse(["#ip " <> ipr | ops]) do
    %__MODULE__{
      ipr: String.to_integer(ipr),
      registers: {0, 0, 0, 0, 0, 0},
      ops: parse_ops(ops)
    }
  end

  defp parse_ops(ops) do
    ops
    |> Enum.map(&parse_op/1)
    |> Enum.with_index()
    |> Map.new(fn {op, i} -> {i, op} end)
  end

  defp parse_op(<<opcode::binary-4>> <> " " <> operands) do
    operands = AOC.Day16.parse_op(operands)
    {String.to_atom(opcode), operands}
  end

  def run(program) do
    case load_op(program) do
      :halt ->
        update_ip(program, &(&1 - 1))

      op ->
        program
        |> execute(op)
        |> update_ip(&(&1 + 1))
        |> run()
    end
  end

  def update_ip(program, fun) do
    ip = elem(program.registers, program.ipr)
    %{program | registers: put_elem(program.registers, program.ipr, fun.(ip))}
  end

  def load_op(program) do
    ip = elem(program.registers, program.ipr)
    # IO.inspect(ip, label: "ip")
    # IO.inspect(Map.get(program.ops, ip), label: ip)
    Map.get(program.ops, ip, :halt)
  end

  def execute(program, {opcode, operands}) do
    # IO.inspect(operands, label: opcode)
    # IO.inspect(program.registers, label: "i")
    # [
    #   String.pad_leading(to_string(elem(program.registers, program.ipr)), 2),
    #   opcode,
    #   inspect(operands),
    #   format_registers(AOC.Day16.op(opcode, operands, program.registers))
    # ] |> Enum.join(" ") |> IO.puts
    # # Process.sleep(100)

    %{program | registers: AOC.Day16.op(opcode, operands, program.registers)} # |> IO.inspect(label: "o")}
  end

  defp format_registers(r) do
    r
    |> Tuple.to_list()
    |> Enum.map(&to_string/1)
    |> Enum.map(&String.pad_trailing(&1, 3))
    |> Enum.join(" ")
  end
end
