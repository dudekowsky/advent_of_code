values = Enum.reduce(File.stream!("day15input"), [], fn line, acc ->
[_name, _, cap, _, dur, _, flav, _, text, _, _cal] = line |> String.replace( [",",".",":"], "") |> String.strip |> String.split
val = [cap, dur, flav, text, _cal] |> Enum.map(&String.to_integer(&1))
acc ++ [val]
end)
[a1, a2, a3, a4, a5] = Enum.at(values, 0)
[b1, b2, b3, b4, b5] = Enum.at(values, 1)
[c1, c2, c3, c4, c5] = Enum.at(values, 2)
[d1, d2, d3, d4, d5] = Enum.at(values, 3)


combinations = for ax <-0..100 do
  for bx <- 0..(100 - ax) do
    for cx <- 0..(100 - ax - bx) do
      for dx <- 0..(100 - ax - bx - cx), (ax + bx + cx + dx ) == 100, do: [ax,bx,cx,dx]
    end
  end
end

comb = List.flatten(combinations) |> Enum.chunk(4)

Enum.reduce(comb, 0, fn [ax,bx,cx,dx], acc ->
  br = cr = dr = 0
  ar = (ax * a1 + bx * b1 + cx * c1 + dx * d1)
  if (ar > 0), do: br = (ax * a2 + bx * b2 + cx * c2 + dx * d2)
  if (br > 0), do: cr = (ax * a3 + bx * b3 + cx * c3 + dx * d3)
  if (cr > 0), do: dr = (ax * a4 + bx * b4 + cx * c4 + dx * d4)
  if (dr > 0 and (ar*br*cr*dr) > acc), do: acc = (ar*br*cr*dr)
  IO.puts acc
  acc
end
)
|> IO.puts
