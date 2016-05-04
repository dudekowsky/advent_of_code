
defmodule GameOfLights do
  def iterate(map, 0) do
    map
  end
  def iterate(map, n) do
    map = do_iterate(map)
    n = n-1
    iterate(map, n)
  end

  def do_iterate(map) do
    frozen_map = map
    map = for {{x,y}, val} <- map, into: %{} do
      new_val = neighbours({x,y})
      |> Enum.map(fn {crd_x, crd_y} ->
        sign = Map.get(frozen_map, {crd_x, crd_y}, ".")
        case sign do
          "." -> 0
          "#" -> 1
        end
      end)
      |> Enum.sum
      |> apply_rules(Map.get(frozen_map, {x,y}))

      {{x,y}, new_val}
    end
    [{0,0},{0,99},{99,0},{99,99}]
    |> Enum.reduce(map, fn(x, acc) ->
      Map.put(acc, x, "#")
    end)
  end

  def apply_rules(count, "#") when count in [2,3] do
    "#"
  end
  def apply_rules(_, "#") do
    "."
  end
  def apply_rules(3 ,".") do
    "#"
  end
  def apply_rules(_,_) do
    "."
  end

  def neighbours({x,y}) do
    for xmod <- -1..1, ymod <- -1..1, !(xmod == 0 and ymod == 0) do
      {x + xmod, y + ymod}
    end
  end
end
{lights, _} = Enum.reduce(File.stream!("day18input"), {Map.new, 0}, fn line, {map,y} ->
  list = line |> String.strip |> String.codepoints
  map = for x <- 0..99, into: map do
    key = {x,y}
    val = Enum.at(list, x)
    {key, val}
  end

  {map, y + 1}


end)

GameOfLights.iterate(lights,100)
|> Map.values
|> Enum.count(fn x -> x == "#" end)
|> IO.inspect
