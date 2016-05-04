input_stream = File.stream!("listcounterinput")
{e_size, de_size} = Enum.reduce(input_stream, {0,0}, fn line, {e_size, de_size} ->
  line = String.strip(line)
  escaped = Macro.to_string(quote do: unquote(line))
  {e_size + String.length(line), de_size + String.length escaped}
end)
IO.puts (de_size - e_size)
