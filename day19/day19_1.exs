calibratestring = File.read!("day19input2")
repl_map = File.stream!("day19input") |> Enum.reduce(Map.new, fn(line, map) ->
  [element, _, replacement] = line |> String.strip |> String.split
  Map.update(map, element, MapSet.new([replacement]), fn mapset ->
    MapSet.put(mapset, replacement)
  end)
end)

defmodule Calibrater do
  def start(calstring, repl_map) do
    calstring
    |> to_char_list
    |> reducer
    |> Enum.reduce([], fn(x, acc) ->
      x = to_string(x)
      Map.get(repl_map, x)
      |>       
    end)
  end

  def reducer([head, head2 | tail ]) when head2 in ?A..?Z do
    [[head] | reducer([head2 | tail])]
  end
  def reducer([head, head2 | tail ]) when head2 in ?a..?z do
    [[head,head2] | reducer(tail)]
  end
  def reducer([head | tail]) do
    IO.inspect tail
    [[head] | reducer(tail)]
  end
  def reducer([]), do: []
end

Calibrater.reducer('ArGAl')
|> IO.inspect
# Regex.scan(~r/(h)/, calibratestring, capture: :all_but_first)|> Enum.count
# |> IO.puts
