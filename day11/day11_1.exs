defmodule PassGen do
  def gen(char_list) do
    char_list
    |> count_up
    |> do_gen([], false)
  end

  def do_gen(this, _last, true) do
    this
  end

  def do_gen(this, _last, false) do
    next = this |> count_up
    bool = valid_pw?(next)
    do_gen(next, this, bool)
  end

  def valid_pw?(pw) do
    contains_no_iol(pw) && pair_conditions(pw) && increasing_triplet(pw)
  end

  def increasing_triplet([head, head1, head2 | _]) when (head2 == head1 + 1) and (head1 == head + 1)do
    true
  end
  def increasing_triplet([_head | tail]) do
    increasing_triplet(tail)
  end
  def increasing_triplet([]) do
    false
  end

  def pair_conditions(pw) do
    2 <= count_pairs(pw)
  end

  def count_pairs([head, head | tail]) do
    1 + count_pairs(tail)
  end

  def count_pairs([_head | tail]) do
    count_pairs(tail)
  end

  def count_pairs(_) do
    0
  end

  def contains_no_iol(pw) do
    !Enum.any?(pw, fn x -> Enum.member?('iol', x) end)
  end

  def count_up(list) do
    [head | tail] = Enum.reverse(list)
    {output, _} =
    [head + 1 | tail] |>
    Enum.reduce( {[], 0}, fn(x, {acc, carry}) ->
      new_x = rem(((x + carry) - ?a), 26) + ?a
      new_carry = div(x + carry, ?z + 1)
      {acc ++ [new_x], new_carry}
    end)
    output |> Enum.reverse
  end
end

PassGen.gen('hepxcrrq') |> IO.inspect
PassGen.gen('hepxcrrq') |> PassGen.gen |> IO.inspect
