defmodule AOC.Day24 do
  alias __MODULE__.Group

  def parse({good, bad}) do
    parse_army(good, "good")
    |> Map.merge(parse_army(bad, "bad"))
  end

  def parse_army(army, team) do
    army
    |> Enum.map(&Group.parse/1)
    |> Enum.with_index()
    |> Map.new(fn {group, id} ->
      {"#{team}:#{id}", Group.assign(group, team, "#{team}:#{id}")}
    end)
  end

  def target_selection(groups) do
    groups
    |> Map.values()
    |> Enum.sort_by(&Group.selection_priority/1)
    |> Enum.reverse()
    |> Enum.flat_map_reduce(groups, fn group, remaining ->
      remaining
      |> Map.values()
      |> Enum.filter(&(group.team != &1.team))
      |> (&Group.best_target(group, &1)).()
      |> case do
        {:ok, target} ->
          {[{group.id, target.id}], Map.delete(remaining, target.id)}

        :none ->
          {[], remaining}
      end
    end)
    |> elem(0)
  end

  def attack(selections, groups) do
    selections
    |> Enum.sort_by(fn {group_id, _} -> groups[group_id].initiative end)
    |> Enum.reverse()
    |> Enum.reduce(groups, fn {attacker_id, victim_id}, groups ->
      with {:ok, attacker} <- Map.fetch(groups, attacker_id),
           {:ok, victim} <- Map.fetch(groups, victim_id)
      do
        case Group.attack(attacker, victim) do
          :dead ->
            Map.delete(groups, victim_id)

          victim ->
            Map.put(groups, victim_id, victim)
        end
      else
        _ -> groups
      end
    end)
  end

  def fight(groups) do
    results =
      groups
      |> target_selection()
      # |> IO.inspect(label: "targets")
      |> attack(groups)
      # |> IO.inspect(label: "results")

    results
    |> Map.values()
    |> Enum.map(&(&1.team))
    |> Enum.uniq()
    |> case do
      [winner] ->
        {winner, results}
      _ ->
        if results == groups do
          {nil, results}
        else
          fight(results)
        end
    end
  end

  def boost(groups, n) do
    {winner, winners} =
      groups
      |> Enum.map(fn {k, group} ->
        if group.team == "good" do
          {k, %{group | power: group.power + n}}
        else
          {k, group}
        end
      end)
      |> Map.new()
      # |> IO.inspect(label: "boosted")
      |> fight()

    case winner do
      "good" ->
        winners

      _ ->
        # winners
        boost(groups, n + 1)
    end
  end
end
