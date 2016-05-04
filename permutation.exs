defmodule Perm do
  def permutations([]) do [[]] end
  def permutations(list) do
      for h <- list, t <- permutations(list -- [h]), do: [h | t]
  end
end
