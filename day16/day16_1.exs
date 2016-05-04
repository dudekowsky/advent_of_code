defmodule AuntFinder do
  def start(aunt_map, file) do
    File.stream!("day16input")
    |> (Enum.each( fn line ->
        [_Sue, num, key1, val1, key2, val2, key3, val3] = line
        |> String.strip |> String.replace(",","") |> String.split
        pair1 = [key1, String.to_integer(val1)]
        pair2 = [key2, String.to_integer(val2)]
        pair3 = [key3, String.to_integer(val3)]
        #IO.inspect [pair1,pair2,pair3]
        if (matches(aunt_map, pair1) && matches(aunt_map, pair2) && matches(aunt_map, pair3)) do
          IO.puts num
        end
      end
    )
    )
  end

  def matches(aunt_map, [key, val]) when key in ["cats:", "trees:"] do
    Map.get(aunt_map, key) < val
  end
  def matches(aunt_map, [key, val]) when key in ["pomeranians:", "goldfish:"] do
    Map.get(aunt_map, key) > val
  end

  def matches(aunt_map, [key, val]) do
    Map.get(aunt_map, key) == val
  end
end

aunt_map = "children: 3
cats: 7
samoyeds: 2
pomeranians: 3
akitas: 0
vizslas: 0
goldfish: 5
trees: 3
cars: 2
perfumes: 1"
|> String.split("\n")
|> Enum.reduce(Map.new, fn(line, map) ->
  [key, val] = line |> String.split
  val = String.to_integer val
  Map.put map, key, val
end
)

AuntFinder.start(aunt_map, "day16input")
