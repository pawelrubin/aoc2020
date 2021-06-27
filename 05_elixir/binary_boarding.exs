defmodule BinaryBoarding do
  def to_bitstring(code) do
    codeMap = %{"F" => "0", "B" => "1", "L" => "0", "R" => "1"}

    String.graphemes(code)
    |> Enum.map(fn c -> codeMap[c] end)
  end

  def bitstring_take_int(bitstring, amount) do
    Enum.take(bitstring, amount) |> Enum.join() |> String.to_integer(2)
  end

  def decode_seat_id(code) do
    bits = to_bitstring(code)
    bitstring_take_int(bits, 7) * 8 + bitstring_take_int(bits, -3)
  end
end

seats_ids =
  File.stream!("input.txt")
  |> Stream.map(&String.trim/1)
  |> Stream.map(&BinaryBoarding.decode_seat_id/1)
  |> Enum.to_list()
  |> Enum.sort()

seats_ids |> Enum.max() |> IO.puts()

seats_ids
|> Enum.drop(1)
|> Enum.zip(seats_ids)
|> Enum.find(fn {next, prev} -> prev + 1 != next end)
|> (fn {_, prev} -> IO.puts(prev + 1) end).()
