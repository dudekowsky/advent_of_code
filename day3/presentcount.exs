defmodule HouseCounter do
  def parse_file(file) do
    {:ok, string} =  file |> File.read
    parse_string(string)
  end

  def parse_string(string) do
    string
    |> String.split("")
    |> Enum.reduce([{0,0}], &move(&1,&2))
    |> Enum.uniq
    |> Enum.count
    |> IO.inspect

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
