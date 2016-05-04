defmodule Sleigh do
  def pmap(collection, function) do
    # Get this process's PID
    me = self
    collection
    |>
    Enum.map(fn (elem) ->
      # For each element in the collection, spawn a process and
      # tell it to:
      # - Run the given function on that element
      # - Call up the parent process
      # - Send the parent its PID and its result
      # Each call to spawn_link returns the child PID immediately.
      spawn_link fn -> (send me, { self, function.(elem) }) end
    end) |>
    # Here we have the complete list of child PIDs. We don't yet know
    # which, if any, have completed their work
    Enum.map(fn (pid) ->
      # For each child PID, in order, block until we receive an
      # answer from that PID and return the answer
      # While we're waiting on something from the first pid, we may
      # get results from others, but we won't "get those out of the
      # mailbox" until we finish with the first one.
      receive do { ^pid, result } -> result end
    end)
  end
  # def permutations([]) do
  #   [[]]
  # end
  # def permutations(list) do
  #   for h <- list, t <- permutations(list -- [h]) do
  #     [h | t]
  #   end
  # end

  def permutations(list) do
    
  end

  def find_qe(list) do
    third = Enum.sum(list) |> div(3)

    [first,_,_] = list
    |> permutations
    |> pmap(fn perm ->
      find_doable(perm,third)
    end)
    |> Enum.uniq
    |> Enum.filter(fn entry -> entry != [] end)
    |> leg_space_filter
    |> Enum.min_by(fn [a,_,_] ->
      a
      |> Enum.reduce(1, fn x, acc -> x * acc end)
    end)
    #|> Enum.reduce(1, fn [a,b,c], acc -> x * acc end)
    first
    |> Enum.reduce(1, fn x, acc -> x *acc end)

  end

  def leg_space_filter(list) do
    min_first_load =
    list
    |> Enum.min_by(fn [a,_b,_c] -> length(a) end)
    [comparator,_,_] = min_first_load
    comparator = comparator |> length
    list
    |> Enum.filter(fn [a,_b,_c] -> length(a) == comparator end)
    |> Enum.uniq_by(fn [a,_,_] -> a end)
  end
  def find_doable(perm,third) do
    sum = third * 3
    result = do_find_doable(perm, 1, 0, third,{})
    case result |> List.flatten |> Enum.sum do
      x when x == sum -> result
       _  -> []
    end
  end

  # def do_find_doable(_list,_counter,sum, third,_acc) when sum > third do
  #   []
  # end
  # def do_find_doable(list, splitcounter, _,acc) when splitcounter == length(list) do
  #   acc
  # end
  def do_find_doable(_,_,3,_,acc) do
    Tuple.to_list(acc)
  end
  def do_find_doable(list, splitcounter, part, third, acc) do
      {first, second} = Enum.split(list, splitcounter)
      case Enum.sum first do
        x when x == third ->
          first = Enum.sort(first)
          acc = Tuple.append(acc, first)
          do_find_doable(second, 0, part + 1, third, acc)
        x when x < third ->
          do_find_doable(list, splitcounter + 1, part, third, acc)
        _ -> []
      end
  end
end

weights = File.stream!("day24input")
|> Enum.map(fn line ->
  line
  |> String.strip
  |> String.to_integer
end)

# third = Enum.sum(weights) |> div(3)

Sleigh.find_qe(weights)
|> IO.inspect
