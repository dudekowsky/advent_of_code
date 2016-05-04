defmodule Count do

  def start(target) do
    do_start(target, 0, 0)
  end

  def do_start(target, house_number, result) when result >= target do
    IO.puts (house_number - 1)
  end

  def do_start(target, house_number, _) do
    next = house_number + 1
    count = present_counter(house_number)
    do_start(target, next, count)
  end


  def present_counter(house_number) do
    do_count(house_number, house_number)
  end
   def do_count(_house_number, 0) do
     0
   end
   def do_count(house_number, curr) do
     #IO.puts house_number
      next = curr - 1
      case (rem(house_number, curr)) do
        0 -> 10 * curr + do_count(house_number, next)
        _ ->             do_count(house_number, next)
       end
   end
end

Count.start(34000000)
