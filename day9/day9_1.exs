defmodule TravelingSanta do
    #so how does this work?
    # first it takes the given order,
    # and recurses back until list is empty.
    # every last for-comprehension in every reduction step
    # has to be calculated before it hits the one before.
    # then it adds it returns back empty to the last element.
    # for the last element it then goes back
    # to create a list with the second last arg.
    # the set of elements of "h <- list" then goes to the next
    # iteration, thus the last element is removed and now
    # the only thing left as possible last argument is the second last
    # and then you have 2 lists with 2 elements.
    # these are the second list for comprehension of the
    # third last element  (so they are the t <- permutations)
    # thus it has  [[thirdlast, secondlast, last], [thirdlast, last, secondlast]]
    # and goes to next iteration in h <- list.
    # this will then give [[secondlast, thirdlast, last], [secondlast, last, thirdlast]]
    # and vice versa for the last argument in list.
    # so the rest now is, dare i say, "simple" recursion:
    # for every element you get all the permutations of the things left in the list.
    # this propagates back to the very first element.
    # then you get all the permutations for the second element, and so on.
    # this gives out a list of list and is also pretty cool shit.
  def permutations([]) do
    IO.puts "empty"
    [[]]
  end
  def permutations(list) do
    for h <- list, t <- permutations(list -- [h]) do
      IO.inspect [h | t]
      [h | t]
    end
  end
  def find_best(locations, distances) do
    locations
    |> permutations
    |> Enum.map(&find_total(&1, distances))
    |> Enum.min
  end
  def find_worst(locations, distances) do
    locations
    |> permutations
    |> Enum.map(&find_total(&1, distances))
    |> Enum.max
  end
  def find_total(list,_) when length(list) == 1, do: 0
  def find_total(list, distances) do
    [head, head2 | tail] = list
    next = [head2 | tail]
    Map.get(distances, {head, head2}) + find_total(next, distances)
  end
end

#IO.puts TravelingSanta.permutations(["Belfast", "Dublin", "London"])
#read in distances in a map as: {from, to} => val, {to,from} => val
#read in all possible places as a list
#permutate this list into all possible ways
#calculate total distance of each
#find min
# input_stream = File.stream! "day9input"
# {locations, distances} = Enum.reduce(input_stream, {MapSet.new, Map.new}, fn(line, {locations, distances}) ->
#   [from, to, distance] = Regex.run(~r|(.*?) to (.*?) = (\d+)|, line, capture: :all_but_first)
#   distance = String.to_integer distance
#   distances = distances |> Map.put({from,to}, distance) |> Map.put({to,from}, distance)
#   locations = MapSet.put(locations, from) |> MapSet.put(to)
#   {locations, distances}
# end)
# locations = MapSet.to_list locations
# IO.puts TravelingSanta.find_best(locations, distances)
# IO.puts TravelingSanta.find_worst(locations, distances)
