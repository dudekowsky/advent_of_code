defmodule NoN do
  def parse_file(file) do
    {:ok, string} = file |> File.read
    string
    |> String.split
    |> Enum.filter(&is_nice(&1))
    |> Enum.count
  end

  def is_nice(string) do
    has_3_vowels(string) && twice_in_row(string) && no_evil(string)
  end

  def twice_in_row(string) do
    string
    |> to_char_list
    |> do_twice_in_row
  end

  def do_twice_in_row([a,a | _tail]) do
    true
  end

  def do_twice_in_row([_head | tail]) do
    do_twice_in_row(tail)
  end

  def do_twice_in_row(_) do
    false
  end

  def no_evil(string) do
    !String.contains?(string, ["ab","cd", "pq", "xy"])
  end

  def has_3_vowels(string) do
    3 <= string
    |> String.split("")
    |> Enum.filter(fn x -> Enum.member?(["a","e","i","o","u"],x) end )
    |> Enum.count
    #|> IO.puts
  end
end

IO.puts NoN.parse_file("naughtyinput")
