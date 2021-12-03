defmodule RecLoop do
  def loop(cache, [head | rest]) do
    {_, new_cache} = value_add(cache, head |> String.split(" "))

    loop(new_cache, rest)
  end

  def loop(cache, []) do
    cache
  end

  def value_add(cache, ["forward", value]) do
    {_, new_cache} = Map.get_and_update(cache, :h_loc, fn current_val ->
      { current_val, current_val + String.to_integer(value) }
    end)

     Map.get_and_update(new_cache, :v_loc, fn current_val ->
      { current_val, current_val + cache[:aim] * String.to_integer(value) }
    end)
  end

  def value_add(cache, ["down", value]) do
    Map.get_and_update(cache, :aim, fn current_val ->
      { current_val, current_val + String.to_integer(value) }
    end)
  end

  def value_add(cache, ["up", value]) do
    Map.get_and_update(cache, :aim, fn current_val ->
      { current_val, current_val - String.to_integer(value) }
    end)
  end
end


{ _, contents } = File.read("input_short.txt")
lines = Enum.filter((contents |> String.split("\n")), fn(x) -> x != "" end)
cache = %{h_loc: 0, v_loc: 0, aim: 0}
new_cache = RecLoop.loop(cache, lines)
IO.puts("HLoc: #{new_cache[:h_loc]}, VLoc: #{new_cache[:v_loc]}, * #{new_cache[:h_loc] * new_cache[:v_loc]}")



