defmodule Grid do
  def start_link do
    Agent.start_link(fn -> Map.new end, name: __MODULE__)
    fill_grid
  end

  def fill_grid do
    map = for x <- 0..999, y <- 0..999, into: %{}, do: {{x,y}, 0}
    Agent.update( __MODULE__, fn _oldmap -> map end)
  end

  def count_lit do
    Agent.get(__MODULE__, fn map -> map end)
    |> Map.values
    |> Enum.sum
  end

  def get(x,y) do
    Agent.get(__MODULE__, fn map -> Map.get map, {x,y} end)
  end

  def set(x,y,val) do
    Agent.update(__MODULE__, fn map -> Map.update!(map, {x,y}, fn _ -> val end) end)
  end

  def turn_on([a,b], [c,d]) do
    Agent.update(__MODULE__, fn map -> for x <- a..c, y <- b..d, into: map, do: {{x,y}, (Map.get(map, {x,y})) + 1} end)
  end

  def turn_off([a,b], [c,d]) do
    Agent.update(__MODULE__, fn map -> for x <- a..c, y <- b..d, into: map, do: {{x,y}, Enum.max([0,(Map.get(map, {x,y})) - 1])} end)
  end

  def toggle([a,b], [c,d]) do
    Agent.update(__MODULE__, fn map -> for x <- a..c, y <- b..d, into: map, do: {{x,y}, (Map.get(map, {x,y})) + 2} end)
  end


end

defmodule FileParser do
  def parse_file(file) do
    Grid.start_link
    {:ok, string} = file |> File.read
    string
    |> String.split("\n")
    |> Enum.map(&to_char_list(&1))
    |> Enum.each(&follow_instruction(&1))


    IO.puts Grid.count_lit
  end

  def follow_instruction('turn on ' ++ rest) do
    {a, rest} = find_number(rest)
    {b, rest} = find_number(rest)
    {c, rest} = find_number(rest)
    {d, _rest} = find_number(rest)
    [a,b,c,d] = [a,b,c,d] |> Enum.map(&to_string(&1)) |> Enum.map(&String.to_integer(&1))
    Grid.turn_on([a,b],[c,d])

  end

  def follow_instruction('toggle ' ++ rest) do
    {a, rest} = find_number(rest)
    {b, rest} = find_number(rest)
    {c, rest} = find_number(rest)
    {d, _rest} = find_number(rest)
    [a,b,c,d] = [a,b,c,d] |> Enum.map(&to_string(&1)) |> Enum.map(&String.to_integer(&1))
    Grid.toggle([a,b],[c,d])
  end

  def follow_instruction('turn off ' ++ rest) do
    {a, rest} = find_number(rest)
    {b, rest} = find_number(rest)
    {c, rest} = find_number(rest)
    {d, _rest} = find_number(rest)
    [a,b,c,d] = [a,b,c,d] |> Enum.map(&to_string(&1)) |> Enum.map(&String.to_integer(&1))
    Grid.turn_off([a,b],[c,d])
  end

  def follow_instruction(_) do

  end

  def find_number(list) do
    do_find_number(list, [])
  end


  def do_find_number([?,|tail], acc) do
    {acc, tail}
  end
  def do_find_number('through ' ++ tail, acc) do
    do_find_number(tail, acc)
  end
  def do_find_number(' ' ++ tail, acc) do
    {acc, tail}
  end

  def do_find_number([head | tail], acc) do
    new_acc = acc ++ [head]
    do_find_number(tail, new_acc)
  end

  def do_find_number(_,acc) do
    {acc, []}
  end



end
FileParser.parse_file("gridinput")
# Grid.start_link
# FileParser.follow_instruction('toggle 0,0 through 999,999')
IO.puts Grid.count_lit
