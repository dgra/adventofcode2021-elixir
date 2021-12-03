defmodule Day3 do
  def loop(cache, [head | tail]) do
    line_array = head |>
      String.graphemes |>
      Enum.map(&(String.to_integer(&1)))

    new_cache = inner_loop(cache, line_array)

    loop(new_cache, tail)
  end

  def loop(cache, []) do
    cache
  end

  def inner_loop([curr_cache | rest_cache], [head | tail]) do
    cache = set_bit(curr_cache, head)
    [cache | inner_loop(rest_cache, tail)]
  end

  def inner_loop([], []) do
    []
  end

  def set_bit(cache, 0) do
    %{
      on: cache[:on],
      off: cache[:off] + 1
    }
  end

  def set_bit(cache, 1) do
    %{
      on: cache[:on] + 1,
      off: cache[:off]
    }
  end

  def get_gamma_rate([head | tail], rev_idx) do
    acc = get_gamma_rate(tail, rev_idx - 1)
    binary_val = if head[:off] >= head[:on], do: 0, else: 1

    acc + (binary_val * :math.pow(2, rev_idx))
  end

  def get_gamma_rate([], -1) do 0 end

  def get_epsilon_rate([head | tail], rev_idx) do
    acc = get_epsilon_rate(tail, rev_idx - 1)
    binary_val = if head[:off] >= head[:on], do: 1, else: 0

    acc + (binary_val * :math.pow(2, rev_idx))
  end

  def get_epsilon_rate([], -1) do 0 end
end

options = OptionParser.parse(["--file", "input.txt"], strict: [file: :string])
filename = elem(options, 0)[:file]
IO.puts("Options: #{filename}")
{ _, contents } = File.read(filename)
lines = Enum.filter((contents |>
  String.split("\n")), fn(x) -> x != "" end)

cache = [%{on: 0, off: 0}, %{on: 0, off: 0}, %{on: 0, off: 0}, %{on: 0, off: 0}, %{on: 0, off: 0}, %{on: 0, off: 0}, %{on: 0, off: 0}, %{on: 0, off: 0}, %{on: 0, off: 0}, %{on: 0, off: 0}, %{on: 0, off: 0}, %{on: 0, off: 0}]

new_cache = Day3.loop(cache, lines)
gamma_rate = Day3.get_gamma_rate(new_cache, length(new_cache) - 1)
epsilon_rate = Day3.get_epsilon_rate(new_cache, length(new_cache) - 1)
IO.puts("G: #{gamma_rate}")
IO.puts("E: #{epsilon_rate}")
IO.puts("G*E: #{gamma_rate * epsilon_rate}")
