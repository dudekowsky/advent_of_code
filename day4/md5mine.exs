defmodule Miner do
  def mine(base) do
    do_mine(base, 0, false)
  end

  def do_mine(_, num, true) do
    IO.puts "Number is #{num - 1}"
  end

  def do_mine(base, num, false) do
    test_string = base <> to_string(num)
    bool = :crypto.md5(test_string) |> Base.encode16 |> String.starts_with?("000000")
    next_num = num + 1
    do_mine(base, next_num, bool)
  end
end

Miner.mine("ckczppom")
