defmodule LookSay do


  def looksay(number) do
    number
    |> to_char_list
    |>do_looksay(1)

  end
  def do_looksay([head], counter) do
    to_char_list(counter) ++ [head]
  end
  def do_looksay([head, head | tail], counter) do
    do_looksay([head | tail], counter + 1)
  end

  def do_looksay([head, next |tail], counter) do
    to_char_list(counter) ++ [head] ++ do_looksay([next |tail], 1)
  end

  def parse_tuple({num, list}) do
    listcountstring = Enum.count(list) |> to_string
    listcountstring <> (to_string(num))
  end

  def times(arg,0) do
    arg
  end

  def times(list, counter) do
    times(looksay(list), counter - 1)
  end

end
IO.inspect LookSay.looksay(1)
IO.inspect LookSay.looksay(11)
IO.inspect LookSay.looksay(21)
IO.inspect LookSay.looksay(1211)
IO.inspect LookSay.looksay(111221)
#answer 1:
IO.inspect LookSay.times(3113322113,40) |> Enum.count

#answer 2:
IO.inspect LookSay.times(3113322113,50) |> Enum.count
