@input = File.readlines('day24input').map(&:to_i)

def find_smallest_quantum(wanted_weight)
  all = (4..7).flat_map{|size| @input.combination(size).select {|a|a.reduce(:+) == wanted_weight}.sort}
  smallest = nil
  quantum_smallest = nil
  all.each do |e|
    smallest = e.length if smallest.nil?
    break if e.length > smallest
    quantum = e.reduce(:*)
    if (quantum_smallest.nil? || quantum < quantum_smallest)
      quantum_smallest = quantum
    end
  end
  quantum_smallest
end


total_weight = @input.reduce(:+)

puts "part1: #{find_smallest_quantum(total_weight/3)}"
puts "part2: #{find_smallest_quantum(total_weight/4)}"
