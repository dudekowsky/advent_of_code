defmodule HouseCounter do
  def parse_file(file) do
    {:ok, string} =  file |> File.read
    parse_fullstring(string)
  end
  def parse_fullstring(string) do
    [robo, santa] = split_instructions(string)
    parse_string(robo) ++ parse_string(santa)
    |> Enum.uniq
    |> Enum.count
    |> IO.puts
  end

  def split_instructions(string) do
    string
    |> to_char_list
    |> do_split_instructions(0, {'',''})
    |> Tuple.to_list
    |> Enum.map(&to_string([&1]))
    |> IO.inspect
  end

  def do_split_instructions('', _, acc) do
    acc
  end

  def do_split_instructions([head|tail], 0, {santa, robot}) do
    do_split_instructions(tail, 1, {santa ++ [head], robot})
  end
  def do_split_instructions([head|tail], 1, {santa, robot}) do
    do_split_instructions(tail, 0, {santa , robot ++ [head]})
  end

  def parse_string(string) do
    string
    |> String.split("")
    |> Enum.reduce([{0,0}], &move(&1,&2))
  end

  def move(direction, [head|tail]) do
    new_tuple = do_move(direction, head)
    [new_tuple] ++ [head|tail]
  end

  def do_move(">", {a,b}) do
    {a+1,b}
  end
  def do_move("<", {a,b}) do
    {a-1,b}
  end
  def do_move("^", {a,b}) do
    {a,b+1}
  end
  def do_move("v", {a,b}) do
    {a,b-1}
  end
  def do_move(_,_) do
    {0,0}
  end

end

HouseCounter.parse_file("housecounterinput")
