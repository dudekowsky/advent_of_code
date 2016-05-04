defmodule Logic do
  use Bitwise
  def start_link do
    for x <- ?a..?z, y <- ?a..?z, do: spawn_process([x,y])
    for x <- ?a..?z, do: spawn_process([x])
  end

  def spawn_process(charlist) do
    id = List.to_atom charlist
    pid = spawn(Logic, :process, [nil])
    Process.register(pid, id)
  end

  def process(nil) do
    receive do
      {:setstate, state} ->
        IO.puts "set as #{state}"
        process(state)
      {:getstate, sender} ->
        receive do
          {:setstate, state} ->
            send sender, {:state,state}
            IO.puts "message sent"
            process(state)
        end
    end
  end



  def process(state) do
    receive do
      {:getstate, sender} ->
        send sender, {:state, state}
        process(state)
    end
  end

  def get(id) do
    send id, {:getstate, self}
    receive do
      {:state, state} ->
        state
    end
  end
  def and_sender2(id1, id2, target) do
    state = (id1 &&& get(id2))
    send target, {:setstate, state }
  end
  def and_sender(id1, id2, target) do
    state = (get(id1) &&& get(id2))
    send target, {:setstate, state }
  end

  def or_sender(id1, id2, target) do
    state = get(id1) ||| get(id2)
    send target, {:setstate, state }
  end

  def lsh_sender(id1, shift, target) do
    state = get(id1) <<< shift
    send target, {:setstate, state }
  end

  def rsh_sender(id1, shift, target) do
    state = get(id1) >>> shift
    send target, {:setstate, state}
  end

  def not_sender(id1, target) do
    state = bnot(get(id1)) + 65536
    send target, {:setstate, state}
  end
  def state_sender(state, target) do
    send target,{:setstate, state}
  end

  def wait_for(id) do
    send id, {:getstate, self}
    receive do
      msg ->
        IO.inspect id
        IO.inspect msg
    end
  end

end
defmodule LogicParser do
  def parse_file(file) do
    Logic.start_link
    {:ok, string} = file |> File.read
    string
    |> String.split("\n")
    |> Enum.each(&parse_line(&1))

  end

  def parse_line(statement) do
    IO.puts statement
    statement = statement |> String.split
    spawn(LogicParser, :do_parse, [statement])
  end

  def do_parse([int, _, target]) do
    if Enum.member?(Enum.map(0..65535, &to_string(&1)), int) do
      int = String.to_integer int
    else
      send (String.to_atom int), {:getstate, self}
      receive do
        msg -> {:state, int} = msg
      end
    end
    target = String.to_atom target
    Logic.state_sender int, target
  end

  def do_parse(["NOT", id1, _, target]) do
    id1 = String.to_atom id1
    target = String.to_atom target
    Logic.not_sender id1, target
  end

  def do_parse([id1, "AND", id2, _, target]) do
    if Enum.member?(Enum.map(0..65535, &to_string(&1)), id1) do
      id1 = String.to_integer id1
      id2 = String.to_atom id2
      target = String.to_atom target
      Logic.and_sender2 id1, id2, target
    else
      id1 = String.to_atom id1
      id2 = String.to_atom id2
      target = String.to_atom target
      Logic.and_sender id1, id2, target
    end
  end

  def do_parse([id1, "OR", id2, _, target]) do
    id1 = String.to_atom id1
    id2 = String.to_atom id2
    target = String.to_atom target
    Logic.or_sender id1, id2, target
  end

  def do_parse([id1, "LSHIFT", shift, _, target]) do
    id1 = String.to_atom id1
    shift = String.to_integer shift
    target = String.to_atom target
    Logic.lsh_sender id1, shift, target
  end
  def do_parse([id1, "RSHIFT", shift, _, target]) do
    id1 = String.to_atom id1
    shift = String.to_integer shift
    target = String.to_atom target
    Logic.rsh_sender id1, shift, target
  end
  def do_parse(_) do
    #
  end
end
LogicParser.parse_file "bitlogicinput"
Logic.wait_for(:a)
Logic.state_sender
