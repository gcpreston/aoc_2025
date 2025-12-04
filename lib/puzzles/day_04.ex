# Next time, use :array for better representation

defmodule Aoc2025.Day04 do
  def part_1(input) do
    # IDEA
    # - For each {row, col} combination:
    #   * Get all neighbors
    #   * sum all neighbors
    #   * count if < 4

    parse_input(input)
    |> removable_positions()
    |> length()
  end

  def part_2(input) do
    parse_input(input)
    |> continuously_removable()
    |> length()
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

  defp removable_positions(data) do
    Enum.reduce(data, [], fn {pos, val}, acc ->
      if val == 1 do
        neighbor_total =
          neighbors(pos)
          |> Enum.map(fn n -> Map.get(data, n, 0) end)
          |> Enum.sum()

        if neighbor_total < 4, do: [pos | acc], else: acc
      else
        acc
      end
    end)
  end

  def continuously_removable(data), do: continuously_removable(data, [])

  def continuously_removable(data, acc) do
    case removable_positions(data) do
      [] ->
        acc

      removable ->
        acc = removable ++ acc
        remove_map = Enum.reduce(removable, %{}, fn p, m -> Map.put(m, p, 0) end)
        new_data = Map.merge(data, remove_map)
        continuously_removable(new_data, acc)
    end
  end
end
