defmodule EggNog do

  def part1(list, target) do
    for count <- 1..Enum.count(list) do
      combinations(list, count)
    end
    |> Enum.reduce([], fn(x, acc) ->
      Enum.concat(acc, x)
    end)
    |> Enum.filter(fn x -> Enum.sum(x) == target end)
    |> Enum.count

  end
  def combinations(_, 0), do: [[]]
  def combinations([], _), do: []
  def combinations([x|xs], n) do
    (for y <- combinations(xs, n - 1), do: [x|y]) ++ combinations(xs, n)
  end
end
container_list = File.stream!("day17input")
|> Enum.reduce([], fn line,acc ->
  line = line |> String.strip
  |>String.to_integer
  [line | acc]
end)
#|> IO.inspect
EggNog.part1(container_list, 150)
# #|> List.flatten
|> IO.inspect
