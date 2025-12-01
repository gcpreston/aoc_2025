defmodule Aoc2025.Day01 do
  def part_1(input) do
    clicks = parse_input(input)

    {_last_cur, zero_count} =
      Enum.reduce(clicks, {50, 0}, fn n, {cur, zero_count} ->
        new_cur = next_cursor(cur, n)
        {new_cur, (if new_cur == 0, do: zero_count + 1, else: zero_count)}
      end)

    zero_count
  end

  defp parse_input(input) do
    Enum.map(input |> String.trim() |> String.split("\n"), &parse_line/1)
  end

  defp parse_line("L" <> n_str), do: -1 * String.to_integer(n_str)
  defp parse_line("R" <> n_str), do: String.to_integer(n_str)

  defp next_cursor(cur, clicks) do
    delta = rem(clicks, 100)
    sum = cur - delta

    cond do
      sum < 0 -> 100 + sum
      sum > 99 -> rem(sum, 100)
      true -> sum
    end
  end
end
