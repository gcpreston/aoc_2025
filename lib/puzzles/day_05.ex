defmodule Aoc2025.Day05 do
  def part_1(input) do
    {ranges, ids} = parse_input(input)

    Enum.reduce(ids, 0, fn id, fresh_count ->
      if Enum.any?(ranges, fn range -> id in range end) do
        fresh_count + 1
      else
        fresh_count
      end
    end)
  end

  def part_2(input) do

  end

  def parse_input(input) do
    [fresh_ranges, id_strs] = String.split(input, "\n\n")

    ranges =
      fresh_ranges
      |> String.split("\n")
      |> Enum.map(fn range_str ->
        [start, stop] =
          range_str
          |> String.split("-")
          |> Enum.map(&String.to_integer/1)
        start..stop
      end)

    ids =
      id_strs
      |> String.split("\n")
      |> Enum.map(&String.to_integer/1)

    {ranges, ids}
  end
end
