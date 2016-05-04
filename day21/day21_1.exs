
weapons = "Dagger        8     4       0
Shortsword   10     5       0
Warhammer    25     6       0
Longsword    40     7       0
Greataxe     74     8       0"

armor = "None          0     0       0
Leather      13     0       1
Chainmail    31     0       2
Splintmail   53     0       3
Bandedmail   75     0       4
Platemail   102     0       5"

rings = "None +0        0     0       0
Damage +1    25     1       0
Damage +2    50     2       0
Damage +3   100     3       0
Defense +1   20     0       1
Defense +2   40     0       2
Defense +3   80     0       3"

weapon_list = weapons
|> String.split("\n")
|> Enum.map( fn line ->
    [_name, cost, dmg, defense] = line |> String.strip |> String.split
    [cost,dmg,defense]
    |> Enum.map(&String.to_integer(&1))
  end)

ring_list = rings
|> String.split("\n")
|> Enum.map( fn line ->
  [_name,_, cost, dmg, defense] = line |> String.strip |> String.split
  [cost,dmg,defense]
  |> Enum.map(&String.to_integer(&1))
end)

armor_list = armor
|> String.split("\n")
|> Enum.map( fn line ->
  [_name, cost, dmg, defense] = line |> String.strip |> String.split
  [cost,dmg,defense]
  |> Enum.map(&String.to_integer(&1))
end)


defmodule RPG do
  def find_cheapest(weapons,armors, rings, enemy) do
    combinations(weapons, armors, rings)
    |> Enum.filter(fn x -> beat_boss(x, enemy) end)
    |> Enum.min_by(fn x -> total_cost(x) end)
    |> total_cost
  end
  def total_cost(list) do

    sum = list
    |> Enum.map(fn x -> Enum.at(x, 0) end)
    |> Enum.sum
    IO.puts sum
    sum
  end
  def combinations(weapons, armors, rings) do
    for a <- weapons, b <- armors, c <- rings, d <- rings, c != d do
      [a,b,c,d]
    end
  end

  def beat_boss(item_list, enemy) do
    enemy_hp = Enum.at(enemy, 0)
    boss_dmg = Enum.at(enemy, 1)
    boss_armor = Enum.at(enemy, 2)
    own_armor = item_list |> Enum.map(fn x -> Enum.at(x,2) end)|> Enum.sum
    own_dmg = item_list |> Enum.map(fn x -> Enum.at(x,1) end) |> Enum.sum
    case (boss_dmg > own_armor) do
      true -> lifetime_self = (100.0 / (boss_dmg - own_armor)) |> Float.ceil
              lifetime_boss = (enemy_hp / (own_dmg - boss_armor)) |> Float.ceil
              lifetime_self >= lifetime_boss
      false ->
              true
    end
  end
end
_enemy = "Hit Points: 103
Damage: 9
Armor: 2"
enemy = [103, 9, 2]


RPG.find_cheapest(weapon_list, armor_list, ring_list, enemy)
|> IO.inspect
