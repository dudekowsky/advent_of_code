defmodule Snow do
  def find_nth(x,y,start) do
    do_find_nth(start, nth(x,y))
  end
  def do_find_nth(val, 1) do
    val
  end
  def do_find_nth(val, counter) do
    counter = counter - 1
    val * 252533
    |> rem(33554393)
    |> do_find_nth(counter)
  end
  def nth(x,y) do
    Enum.sum(1..x) +
    Enum.sum(x..(x+y-2))
  end
end

row = 2981
column = 3075
start = 20151125
Snow.find_nth(column,row, start)
|> IO.puts
