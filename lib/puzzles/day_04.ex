# Next time, use :array for better representation

defmodule Aoc2025.Day04 do
  def part_1(input) do
    # IDEA
    # - For each {row, col} combination:
    #   * Get all neighbors
    #   * sum all neighbors
    #   * count if < 4

    data = parse_input(input)

    Enum.reduce(data, 0, fn {pos, val}, acc ->
      if val == 1 do
        neighbor_total =
          neighbors(pos)
          |> Enum.map(fn n -> Map.get(data, n, 0) end)
          |> Enum.sum()

        if neighbor_total < 4, do: acc + 1, else: acc
      else
        acc
      end
    end)
  end

  def part_2(input) do

  end

  def parse_input(input) do
    String.split(input, "\n")
    |> parse_input_lines(0, %{})
  end

  defp parse_input_lines([], _line_no, acc), do: acc

  defp parse_input_lines([line | rest], line_no, acc) do
    line_data = parse_line(line, line_no)
    parse_input_lines(rest, line_no + 1, Map.merge(acc, line_data))
  end

  defp parse_line(line, line_no) do
    for {char, col} <- Enum.with_index(String.graphemes(line)), into: %{} do
      {{line_no, col}, (if char == "@", do: 1, else: 0)}
    end
  end

  defp neighbors({r, c}) do
    [
      {r - 1, c - 1}, {r - 1, c}, {r - 1, c + 1},
      {r, c - 1}, {r, c + 1},
      {r + 1, c - 1}, {r + 1, c}, {r + 1, c + 1}
    ]
  end
end
