defmodule Dinner do
  def find_best(file) do
    {shifts, guests} = parse_input(file)
    guests = MapSet.to_list(guests) ++ ["Me"]
    permutations(guests)
    |> Enum.map(&happyness_value(&1,shifts))
    |> Enum.max
  end
  def permutations([]) do
    [[]]
  end
  def permutations([h | tail] = list ) do
    for h <- list, t <- permutations(list -- [h]) do
      [h | t]
    end
  end

  def happyness_value(list, shifts) do
    first = hd(list)
    last = hd(Enum.reverse(list))
    Map.get(shifts,{first,last},0) + Map.get(shifts,{last,first},0) +
    do_reduce(list, shifts)
  end

  def do_reduce([_head], shifts) do
    0
  end

  def do_reduce([head, head2 | tail], shifts) do
    Map.get(shifts, {head, head2},0) +
    Map.get(shifts, {head2, head},0) +
    do_reduce([head2 | tail], shifts)
  end

  def parse_input(file) do
    Enum.reduce(File.stream!(file), {Map.new, MapSet.new}, fn line, {shifts, guests} ->
      [a,_, mod, num, _, _,_,_,_,_, b] = line |> String.strip |> String.replace_suffix(".","") |> String.split
      case mod do
        "gain"  -> {Map.put(shifts, {a,b}, String.to_integer(num)), (MapSet.put(guests, a)|>MapSet.put(b))}
        _       -> {Map.put(shifts, {a,b}, -String.to_integer(num)), (MapSet.put(guests, a)|>MapSet.put(b))}
      end
    end
    )
  end
end

IO.inspect Dinner.find_best("day13input")
