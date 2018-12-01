defmodule Mix.Tasks.Solve do
  use Mix.Task

  def run([day, part]) do
    day = to_string(day)
    part = to_string(part)
    result =
      with_input(day, fn input ->
        AOC.day(day, part, input)
      end)

    Mix.shell.info "Day #{String.pad_leading(day, 2)}, Part #{part}: #{result}"
  end
  def run([day]) do
    Enum.each([1, 2], &run([day, &1]))
  end
  def run([]) do
    Enum.each(1..25, &run([&1]))
  end


  defp with_input(day, fun) do
    AOC.input(day)
    |> Enum.map(&AOC.to_integer/1)
    |> fun.()
  rescue
    File.Error -> "No Input"
  end
end
