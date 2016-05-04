# ["hlf", reg]
# ["tpl", reg]
# ["inc", reg]
# ["jmp", offset]
# ["jie", reg, offset]
# ["jio", reg, offset]

defmodule Register do
  require Integer
  def follow_instruction(file) do
    instruction_list = File.stream!(file)
    |> Enum.map(fn line ->
      line
      |> String.strip
      |> String.replace(",", "")
      |> String.split

    end)
    map = %{"a" => 1, "b" => 0}
    do_follow(0,map, instruction_list)
  end

  def do_follow(instructionpos, map, list) when instructionpos >= length(list) or instructionpos < 0  do
    IO.puts "a is #{Map.get(map, "a")} and b is #{Map.get(map, "b")}"
  end

  def do_follow(pos,map,list) do
    case Enum.at(list, pos) do
      ["hlf", reg] ->
        map = Map.update(map, reg, 0, fn x -> div(x,2)end )
        pos = pos + 1
      ["tpl", reg] ->
        map = Map.update(map, reg, 0, fn x -> x * 3 end )
        pos = pos + 1
      ["inc", reg] ->
        map = Map.update(map, reg, 0, fn x -> x + 1 end )
        pos = pos + 1
      ["jmp", offset] ->
        pos = pos + String.to_integer(offset)
      ["jie", reg, offset] ->
        if ( Integer.is_even(Map.get(map, reg)) ) do
          pos = pos + String.to_integer( offset)
        else
          pos = pos + 1
        end
      ["jio", reg, offset] ->
        if (Map.get(map,reg) == 1) do
          pos = pos + String.to_integer( offset)
        else
          pos = pos + 1
        end
      end
    do_follow(pos, map, list)
  end
end

Register.follow_instruction("day23input")
