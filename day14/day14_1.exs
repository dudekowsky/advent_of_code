defmodule Racer do
  def parse_file(file,time) do
    File.stream!(file)
    |>Enum.reduce([], fn line, acc ->
      [a, _can, _fly, num, _kms, _for, t1, _seconds, _but, _then, _must, _rest, _for2, t2, _seconds2] = line |> String.strip |> String.split
      [{a, String.to_integer(num), String.to_integer(t1), String.to_integer(t2)} | acc]
    end)
    |> Enum.map(&calculate_distance(&1, time))
    |> Enum.max

  end

  def calculate_distance({name, speed, go_time, rest_time}, given_time) do
    mean_speed = (go_time* speed + rest_time) / (go_time + rest_time)
    distance = div(given_time, (go_time + rest_time)) * speed* go_time
    leftover_time = rem(given_time, (go_time + rest_time))
    distance = distance + ([leftover_time, go_time] |> Enum.min |> Kernel.*(speed))
  end
end
#Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds
Racer.calculate_distance({"bla", 14, 10, 127}, 1000 )
|> IO.puts
Racer.parse_file("day14input",2504) |> IO.inspect
