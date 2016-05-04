defmodule NoN do
  def parse_file(file) do
    {:ok, string} = file |> File.read
    string
    |> String.split
    |> Enum.filter(&is_nice(&1))
    |> Enum.count
  end

  def is_nice(string) do
    doublepair(string) && letter_gap(string)
  end

  def letter_gap(string) do
    do_letter_gap(string, false)
  end

  def do_letter_gap(_, true) do
    true
  end
  def do_letter_gap("", false) do
    false
  end

  def do_letter_gap(string, false) do
    bool = String.at(string, 0) == String.at(string, 2)
    {_, next_string} = String.split_at(string, 1)
    do_letter_gap(next_string, bool)
  end

  def doublepair(string) do
    do_doublepair(string, false)
  end

  def do_doublepair("", false) do
    false
  end
  def do_doublepair(string, false) do
    {matcher, rest} = String.split_at string, 2
    bool = String.contains? rest, matcher
    {_, next_string } = String.split_at string, 1

    do_doublepair(next_string, bool)
  end

  def do_doublepair(_,true) do
    true
  end
  def do_doublepair("", false) do
    false
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
