defmodule Aoc2025.Day02 do
  # assumes a fixed-length range is given
  defp part_1_invalid_ids_in_fixed_length_range(fixed_range) do
    low..high//1 = fixed_range
    low_prefix = half_length_prefix(low)
    high_prefix = half_length_prefix(high)

    # inner range
    inner_range = (low_prefix + 1)..(high_prefix - 1)//1
    inner_invalids = Enum.map(inner_range, &repeated/1)

    # does the low edge count?
    low_repeated = repeated(half_length_prefix(low))
    low_invalid =  if low_repeated >= low and low_repeated <= high, do: [low_repeated], else: []

    # does the high edge count?
    high_repeated = repeated(half_length_prefix(high))
    high_invalid = if high_prefix != low_prefix and high_repeated >= low and high_repeated <= high, do: [high_repeated], else: []

    low_invalid ++ high_invalid ++ inner_invalids
  end

  # assumes a fixed-length range is given
  defp part_2_invalid_ids_in_fixed_length_range(fixed_range) do
    low..high//1 = fixed_range
    dc = digit_count(low)
    low_prefix = half_length_prefix(low)
    high_prefix = half_length_prefix(high)

    # inner range
    inner_range = (low_prefix + 1)..(high_prefix - 1)//1
    inner_invalids =
      Enum.reduce(inner_range, MapSet.new(), fn prefix, acc ->
        # This does repeated work for prefixes of the same length.
        # If slow, find a way to eliminate more at once.
        # possible_repeats =
        #   for i in 1..digit_count(prefix) do
        #     if rem(dc, i) == 0 do
        #       i_length_prefix = m_length_prefix(prefix, i)
        #       []
        #     else
        #       []
        #     end
        #   end
      end)

    # does the low edge count?
    low_repeated = repeated(half_length_prefix(low))
    low_invalid =  if low_repeated >= low and low_repeated <= high, do: [low_repeated], else: []

    # does the high edge count?
    high_repeated = repeated(half_length_prefix(high))
    high_invalid = if high_prefix != low_prefix and high_repeated >= low and high_repeated <= high, do: [high_repeated], else: []

    low_invalid ++ high_invalid ++ inner_invalids
  end

  # SIMPLEST CASE: range within same even digit count.
  # ex: 20-50
  # - The idea is to check each possible half-length prefix for whether the repeat case is contained.
  # - FOR INTERNAL RANGES, these are automatically included.
  #   * Here, eliminating 2- and 5- we get 3- and 4-, automatically giving us 2 repetitions
  # - FOR EDGE RANGES, check manually if repetition is contained.
  #   * Here, low range: 2- : 22 > 20 => true (high range implied due to multiple possible prefixes)
  #   * Here, high range: 5- : 55 > 50 => false (low range implied due to multipl possible prefixes)
  # - So, the answer is 3.
  #
  # ex: 222220-222345
  # - half-length prefix range: 222-222 => {222}
  # - Just an edge range check, where we do have to check both sides of the single range,
  #   unlike the above example. 222222 > 222220 and 222222 < 222345 => true, so 1 total.
  #
  # ex: 123124-456000
  # - Prefix ranges: 123-456 => (456 - 123 + 1) = 334 prefixes.
  # - INTERNAL RANGES: 332 autos
  # - EXTERNAL RANGES:
  #   * 123123 < 123124 => false
  #   * 456456 > 456000 => false
  # - So the answer is 332.

  # MORE COMPLEX CASE: 95-115
  # - We only care about even digit ranges, so split a range into its different digit length ranges:
  #   95-115 = 95-99 and 100-115 = 95-99
  #
  # ex: 1-999 = 1-9 and 10-99 and 100-999

  # WISHLIST:
  # - repeat_count_in_fixed_length_range : (Range.t()) -> int()
  # - range_to_fixed_length_ranges : (Range.t()) -> [Range.t()]
  # - half_length_prefix : (int()) -> int()
  # - repeat_count : (Range.t()) -> int()
  # - digit_count : (int()) -> int()

  # PART 2 SIMPLEST CASE:
  # - The difference is we need to check repeats for all possible range lengths
  # - A possible range length is a number the digit count is divisible by.
  #   * For simplicity, we could just iterate from 1..digit_count and skip if not divisible.
  #
  # ex: 565653-565659
  # brainstorming
  # - from low end, possible prefixes: 555555, 565656, 565565
  # - can just check these and see that there is one in the range
  # - from high end, possible prefixes: 555555, 565656, 565565
  # - Do set intersection on these values
  #
  # ex: 123000-300000
  # - from low end: 111111, 121212, 123000
  # - max size to check is that half-length prefix, meaning we are looking between 123..300
  # - 124: 111111, 121212, 124124
  # - honestly just iterate thru all and do a set intersection reduction

  def part_1(input) do
    ranges = parse_input(input)

    # reduce to fixed-length ranges
    filtered_fixed_ranges =
      ranges
      |> Enum.map(&range_to_fixed_length_ranges/1)
      |> List.flatten()
      |> Enum.filter(fn low.._//1 -> rem(digit_count(low), 2) == 0 end)

    # sum the invalids in each range
    filtered_fixed_ranges
    |> Enum.map(&part_1_invalid_ids_in_fixed_length_range/1)
    |> List.flatten()
    |> Enum.sum()
  end

  def part_2(input) do
    ranges = parse_input(input)

    # reduce to ranges which may have a double-repeat
    filtered_fixed_ranges =
      ranges
      |> Enum.map(&range_to_fixed_length_ranges/1)
      |> List.flatten()

    # sum the invalids in each range
    filtered_fixed_ranges
    |> Enum.map(&part_2_invalid_ids_in_fixed_length_range/1)
    |> List.flatten()
    |> Enum.sum()
  end

  defp parse_input(input) do
    input
    |> String.split(",")
    |> Enum.map(&parse_range/1)
  end

  defp parse_range(range_str) do
    [low, high] = String.split(range_str, "-")
    String.to_integer(low)..String.to_integer(high)//1
  end

  defp range_to_fixed_length_ranges(range), do: range_to_fixed_length_ranges_helper(range, [])

  defp range_to_fixed_length_ranges_helper(range, acc) do
    low..high//1 = range
    low_count = digit_count(low)

    max_low_count = (10 ** low_count) - 1
    if high > max_low_count do
      range_to_fixed_length_ranges_helper((max_low_count + 1)..high, [low..max_low_count | acc])
    else
      [low..high | acc]
    end
  end

  defp digit_count(n), do: trunc(:math.log10(n)) + 1

  # rounds down if n is odd digit count
  defp half_length_prefix(n) do
    dc = digit_count(n)
    div(n, 10 ** (div(dc, 2)))
  end

  def m_length_prefix(n, m) do
    dc = digit_count(n)
    div(n, 10 ** (dc - m))
  end

  defp repeated(n), do: (n * (10 ** digit_count(n))) + n
end
