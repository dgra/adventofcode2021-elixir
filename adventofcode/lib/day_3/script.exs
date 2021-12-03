defmodule Day3 do
  def compare_o2_counts(counts) do
    if counts[:on] >= counts[:off] do
      1
    else
      0
    end
  end

  def compare_co2_counts(counts) do
    if counts[:on] < counts[:off] do
      1
    else
      0
    end
  end

  def find_winning_bit(binaries, idx, compare_fn) do
    counts = binaries |>
      Enum.reduce(%{on: 0, off: 0}, fn(x, acc) ->
        if Enum.at(x, idx) == 1, do: %{acc | on: acc[:on] + 1}, else: %{acc | off: acc[:off] + 1} end
      )

    compare_fn.(counts)
  end

  def find_binary(binaries, compare_fn) do
    find_binary(binaries, 0, compare_fn)
  end

  def find_binary([last_value], _, _) do
    last_value
  end

  def find_binary(list_of_binaries, idx, compare_fn) do
    bit_of_interest = find_winning_bit(list_of_binaries, idx, compare_fn)

    # IO.puts("iter: idx: #{idx}, boi: #{bit_of_interest}")
    # IO.inspect(list_of_binaries)
    filtered_list = list_of_binaries |>
      Enum.reject(fn(binary_list) ->
        Enum.at(binary_list, idx) != bit_of_interest
      end)

    find_binary(filtered_list, idx + 1, compare_fn)
  end

  # Assumes most significant bit first order.
  def binary_to_dec(binary_list) do
    binary_to_dec(Enum.reverse(binary_list), 0)
  end

  def binary_to_dec([], _) do 0 end

  # Assumes least significant bit first order.
  def binary_to_dec([head | tail], idx) do
    acc = binary_to_dec(tail, idx + 1)
    acc + (head * :math.pow(2, idx))
  end

  def build_bit_counter(bit_size) do
    for _ <- 0..bit_size, do: %{on: 0, off: 0}
  end

  def run(filename) do
    IO.puts("Options: #{filename}")

    { _, contents } = File.read(filename)
    lines = contents |>
      String.split("\n", trim: true) |>
      Enum.map(fn(x) ->
        String.graphemes(x) |>
        Enum.map(&(String.to_integer(&1)))
      end)

    o2_gen_rate = binary_to_dec(find_binary(lines, &compare_o2_counts/1))
    co2_gen_rate = binary_to_dec(find_binary(lines, &compare_co2_counts/1))

    IO.inspect(o2_gen_rate)
    IO.inspect(co2_gen_rate)
    IO.inspect(o2_gen_rate*co2_gen_rate)
  end
end

filename = "input_short.txt"
filename = "input.txt"
Day3.run(filename)
