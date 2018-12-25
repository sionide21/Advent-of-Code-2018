defmodule AOC.Day24.Group do
  defstruct [:id, :team, :units, :hp, :abilities, :type, :power, :initiative]

  def selection_priority(group) do
    {effective_power(group), group.initiative}
  end

  def effective_power(group) do
    group.units * group.power
  end

  def best_target(_group, []) do
    :none
  end
  def best_target(group, victims) do
    victim = Enum.max_by(victims, fn victim ->
      {damage(victim, group.type), effective_power(victim), victim.initiative}
    end)

    if damage(victim, group.type) > 0 do
      {:ok, victim}
    else
      :none
    end
  end

  def attack(group, victim) do
    # IO.puts("#{group.id} attacks #{victim.id}")
    take_damage(victim, group.type, effective_power(group))
  end

  def take_damage(group, type, amount) do
    # damage = (damage(group, type) |> IO.inspect(label: "multiplier")) * IO.inspect(amount, label: "amount")
    damage = damage(group, type) * amount
    units = div(damage, group.hp) # |> IO.inspect(label: "units killed")
    case group.units - units do
      units when units > 0 ->
        # IO.puts("#{group.id} now has #{units} units")
        %{group | units: units}

      _ ->
        # IO.puts("#{group.id} dies")
        :dead
    end
  end

  defp damage(group, type) do
    group.abilities
    |> Map.get(type, :normal)
    |> case do
      :immune -> 0
      :normal -> 1
      :weak -> 2
    end
  end

  def assign(group, team, id) do
    %{group | team: team, id: id}
  end

  def parse(group) do
    ~r/^(?<units>\d+) units each with (?<hp>\d+) hit points (?:\((?<abilities>.+)\) )?with an attack that does (?<power>\d+) (?<type>\w+) damage at initiative (?<initiative>\d+)$/
    |> Regex.named_captures(group)
    |> Enum.map(fn {k, v} -> {String.to_atom(k), v} end)
    |> Enum.map(fn
      {k, v} when k in ~w[hp initiative power units]a ->
        {k, String.to_integer(v)}

      {:abilities, v} ->
        {:abilities, parse_abilities(v)}

      other ->
        other
    end)
    |> (&struct(__MODULE__, &1)).()
  end

  defp parse_abilities(abilities) do
    ~r/^(:?immune to (?<immune>[^;]+))?(:?; )?(?:weak to (?<weak>.+))?$/
    |> Regex.named_captures(abilities)
    |> Enum.flat_map(fn
      {_, ""} ->
        []
      {k, v} ->
        v
        |> String.split(", ")
        |> Enum.map(fn type ->
          {type, String.to_atom(k)}
        end)
    end)
    |> Map.new()
  end
end
