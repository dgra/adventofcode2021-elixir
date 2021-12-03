defmodule Comparator do
  def count_increases([first, second | rest]) do
    increase_value = if first < second, do: 1, else: 0

    count_increases([second | rest]) + increase_value
  end

  def count_increases([_]) do
    0
  end

  def calc_sliding_groups([one, two, three | rest]) do
    [ one + two + three | calc_sliding_groups([two, three | rest])]
  end

  def calc_sliding_groups([_,_]) do [] end
  def calc_sliding_groups([_]) do [] end
end

{ _, contents } = File.read("input.txt")
lines = contents |>
  String.split("\n") |>
  Enum.filter(&(&1 != "")) |>
  Enum.map(&(String.to_integer(&1)))

agg_lines = Comparator.calc_sliding_groups(lines)
IO.puts(Comparator.count_increases(agg_lines))
