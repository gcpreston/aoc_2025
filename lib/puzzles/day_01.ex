defmodule Aoc2025.Day01 do
  @total_clicks 100

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
    delta = rem(clicks, @total_clicks)
    sum = cur + delta

    cond do
      sum < 0 -> @total_clicks + sum
      sum > 99 -> rem(sum, @total_clicks)
      true -> sum
    end
  end

  def part_2(input) do
    clicks = parse_input(input)

    {_last_cur, zero_count} =
      Enum.reduce(clicks, {50, 0}, fn n, {cur, zero_count} ->
        new_cur = next_cursor(cur, n)
        IO.puts("cur #{cur} + clicks #{n} = new cur #{new_cur}")
        {new_cur, zero_count + past_zero_count(cur, n)}
      end)

    zero_count
  end

  # ex:
  # - c(50, 250) -> 3
  defp past_zero_count(_cur, 0), do: 0
  defp past_zero_count(cur, clicks) do
    # cases to go past 0
    # - cur + clicks > 99
    # - cur + clicks <= 0
    # NOPE
    # - the question is "does the set of numbers clicked past include 0"
    # - cur at 0 => need to click 100 times to reach 0 => div(clicks, 100)
    # - cur at 10 => need to click 90 times OR -10 times
    #
    # multiple passes cases
    # - add result of div(clicks, 100)
    effective_delta = rem(clicks, @total_clicks)
    effective_zero_count = if (cur + effective_delta >= @total_clicks or cur + effective_delta <= 0) and cur != 0, do: 1, else: 0
    full_rotation_zero_count = abs(div(clicks, @total_clicks))
    effective_zero_count + full_rotation_zero_count
  end
end
