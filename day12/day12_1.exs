{:ok, string} = File.read("day12input")
Regex.scan( ~r/(-\d+|\d+)/, string,[capture: :all_but_first, global: true])
|> Enum.map(fn [x] -> String.to_integer(x) end)
|> Enum.sum
|> IO.puts

 Regex.scan(~r/{red(\d+)}/, string ,[capture: :all_but_first, global: true])
