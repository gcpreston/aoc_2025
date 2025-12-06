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
    data = parse_input_part_2(input)

    nums =
      Enum.slice(data, 0..(length(data) - 2))
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.map(&list_to_int/1)
      |> list_split(nil)

    ops = Enum.at(data, length(data) - 1) |> Enum.join() |> String.split()

    [ops, nums]
    |> Enum.zip()
    |> Enum.reduce(0, fn {o, n}, total ->
      total + do_operation(o, n)
    end)
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
    unfilled_data =
      input
      |> String.split("\n")
      |> Enum.map(&String.graphemes/1)

    max_len = unfilled_data |> Enum.map(&length/1) |> Enum.max()

    Enum.map(unfilled_data, fn line -> pad(line, max_len, " ") end)
  end

  def pad(list, len, e) do
    diff = len - length(list)
    if diff > 0 do
      list ++ Enum.map(1..diff, fn _ -> e end)
    else
      list
    end
  end

  def list_to_int(list) do
    parse_result =
      list
      |> Enum.join()
      |> String.trim()
      |> Integer.parse()

    case parse_result do
      :error -> nil
      {i, _} -> i
    end
  end

  def list_split(list, by), do: list_split(list, by, [[]])

  def list_split([], _by, acc), do: Enum.reverse(Enum.map(acc, &Enum.reverse/1))
  def list_split([head | rest], by, acc) when head == by, do: list_split(rest, by, [[] | acc])
  def list_split([head | rest], by, [acc_head | acc_rest]), do: list_split(rest, by, [[head | acc_head] | acc_rest])

  def do_operation("+", operands), do: Enum.sum(operands)
  def do_operation("*", operands), do: Enum.product(operands)
end
