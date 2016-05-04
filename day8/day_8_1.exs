defmodule ListCounter do
  def parse_file(file) do
    {:ok, string} = file |> File.read

    sum = string
    |> String.split("\n")
    |> Enum.map(&difference(&1))
    |> Enum.sum
    |> IO.puts

  end

  def difference(string) do
    {evaluated, _} = Code.eval_string string

    case evaluated do
      nil -> 0
      _   ->
        byte_size(string) - (String.codepoints(evaluated) |> Enum.count)
    end
  end

end
# ~S{"\"z"}
# |> ListCounter.difference
# |> IO.puts
ListCounter.parse_file("listcounterinput")
