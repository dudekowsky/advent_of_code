defmodule RacerCalc do
  def parse_file(file,time) do
    mapped = File.stream!(file)
    |>Enum.reduce([], fn line, acc ->
      [a, _can, _fly, num, _kms, _for, t1, _seconds, _but, _then, _must, _rest, _for2, t2, _seconds2] = line |> String.strip |> String.split
      [{a, String.to_integer(num), String.to_integer(t1), String.to_integer(t2)} | acc]
    end)
    |> Enum.map(&calculate_distance(&1, time))

    lead_pos = mapped
    |> Enum.max_by(&elem(&1, 0))
    |> elem(0)
    mapped
    |> Enum.filter(&elem(&1,0) == lead_pos)
    #|> IO.inspect

  end

  def calculate_distance({name, speed, go_time, rest_time}, given_time) do
    #_mean_speed = (go_time* speed + rest_time) / (go_time + rest_time)
    distance = div(given_time, (go_time + rest_time)) * speed* go_time
    leftover_time = rem(given_time, (go_time + rest_time))
    distance = distance + ([leftover_time, go_time] |> Enum.min |> Kernel.*(speed))
    #IO.inspect {distance, name}
    {distance, name}
  end
end
#Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds
# Racer.calculate_distance({"bla", 14, 10, 127}, 1000 )
# |> IO.puts
# Racer.parse_file("day14input",2503) |> IO.inspect
for time <- 1..2503 do
  RacerCalc.parse_file("day14input", time)
end
|> List.flatten
|> Enum.map(fn ({_, name} = x) -> name end)
#|> Enum.group_by(fn(x) -> x end)
#|> Map.to_list
# |> Enum.max_by(fn {name, list} -> Enum.count(list) end)
#|> Enum.map(&Tuple.to_list(&1))
#|> List.flatten
#|> Enum.map(&elem(&1, 1))
#|> Enum.group_by(fn x -> x end)
|> Enum.reduce(%{}, fn(x, acc) -> Map.update(acc, x, 1, &(&1 + 1)) end)
|>IO.inspect
# |> IO.inspect
#|> Enum.map(&elem(&1, 1))
#|> elem(1)
# |> Enum.count
# |> IO.puts
