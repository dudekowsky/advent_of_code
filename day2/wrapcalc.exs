defmodule WrapCalc do
  def parse_line(string) do
    string
    |> String.split("x")
    |> Enum.map(&String.to_integer(&1))
    #|> sum_plus_smallest
    |> tie_math
  end

  def tie_math(list) do
    [a,b,c] = Enum.sort list
    2*a + 2*b + a*b*c
  end

  def sum_plus_smallest([l,h,b]) do
    areas = [l*h,l*b,b*h]
    Enum.min(areas) + (2*Enum.sum(areas))
  end

  def parse_file(file) do
    {:ok, string} =  file |> File.read
    string
    |> String.split
    |> Enum.map(&parse_line(&1))
    |> Enum.sum
  end
end

WrapCalc.parse_file("wrapcalcinput")
|> IO.puts
