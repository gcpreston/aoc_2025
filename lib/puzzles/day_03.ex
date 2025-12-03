defmodule Aoc2025.Day03 do
  def part_1(input) do
    # IDEA
    # For each line length l:
    # 1. Find max digit (and its index i) between indices 0 and l - 2
    # 2. Pair with max digit between indices i + 1 and l - 1

    banks = parse_input(input)

    banks
    |> Enum.map(&compute_joltage/1)
    |> Enum.sum()
  end

  def compute_joltage(bank) do
    first_digit_slice = Enum.slice(bank, 0..(length(bank) - 2))
    first_digit_index = max_index(first_digit_slice)
    first_digit = Enum.at(first_digit_slice, first_digit_index)

    second_digit_slice = Enum.slice(bank, (first_digit_index + 1)..(length(bank) - 1))
    second_digit_index = max_index(second_digit_slice)
    second_digit = Enum.at(second_digit_slice, second_digit_index)

    (first_digit * 10) + second_digit
  end

  def parse_input(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn line ->
      line |> String.graphemes() |> Enum.map(&String.to_integer/1)
    end)
  end

  def max_index([]), do: raise Enum.EmptyError
  def max_index([head | tail]), do: max_index(tail, 1, head, 0)

  defp max_index([], _cur_index, _max_val, max_index), do: max_index

  defp max_index([cur | rest], cur_index, max_val, max_index) do
    if cur > max_val do
      max_index(rest, cur_index + 1, cur, cur_index)
    else
      max_index(rest, cur_index + 1, max_val, max_index)
    end
  end
end
