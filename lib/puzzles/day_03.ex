defmodule Aoc2025.Day03 do
  def part_1(input) do
    # IDEA
    # For each line length l:
    # 1. Find max digit (and its index i) between indices 0 and l - 2
    # 2. Pair with max digit between indices i + 1 and l - 1

    banks = parse_input(input)

    banks
    |> Enum.map(fn bank -> compute_joltage(bank, 2) end)
    |> Enum.sum()
  end

  def part_2(input) do
    parse_input(input)
    |> Enum.map(fn bank -> compute_joltage(bank, 12) end)
    |> Enum.sum()
  end

  def compute_joltage(bank, length), do: compute_joltage(bank, length, [])

  def compute_joltage(_bank, 0, acc), do: Enum.reverse(acc) |> Enum.join() |> String.to_integer()

  def compute_joltage(bank, length, acc) do
    digit_slice = Enum.slice(bank, 0..(length(bank) - length)//1)
    digit_index = max_index(digit_slice)
    digit = Enum.at(digit_slice, digit_index)

    compute_joltage(Enum.slice(bank, (digit_index + 1)..(length(bank) - 1)//1), length - 1, [digit | acc])
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
