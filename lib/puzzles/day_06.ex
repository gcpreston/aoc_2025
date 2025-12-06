defmodule Aoc2025.Day06 do
  def part_1(input) do
    data = parse_input(input)

    Enum.reduce(data, 0, fn [op | nums], grand_total ->
      col_val =
        case op do
          "+" -> Enum.sum(nums)
          "*" -> Enum.product(nums)
        end

      grand_total + col_val
    end)
  end

  def part_2(input) do

  end

  def parse_input(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn line ->
      String.split(line)
      |> Enum.map(fn thing ->
        case Integer.parse(thing) do
          {i, ""} -> i
          :error -> thing
        end
      end)
    end)
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&Enum.reverse/1)
  end

  def parse_input_part_2(input) do
    
  end
end
