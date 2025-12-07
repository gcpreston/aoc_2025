defmodule Aoc2025.Day07 do
  @type pos() :: {integer(), integer()}
  @type data() :: {integer(), [MapSet.t(integer())]} # {start col, splitters}

  def part_1(input) do
    {start, splitters} = parse_input(input)
    count_splits(splitters, MapSet.new([start]), 0)
  end

  def part_2(input) do
    {start, splitters} = parse_input(input)
    count_paths(splitters, %{start => 1})
  end

  @spec parse_input(String.t()) :: data()
  def parse_input(input) do
    [first_line | rest_lines] = String.split(input, "\n")
    start = Enum.find_index(String.graphemes(first_line), fn c -> c == "S" end)

    splitters =
      rest_lines
      |> Enum.map(fn line ->
        line
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.filter(fn {c, _i} -> c == "^" end)
        |> Enum.map(fn {_c, i} -> i end)
        |> MapSet.new()
      end)

    {start, splitters}
  end

  def count_splits([], _beams, count), do: count

  def count_splits([head_splitters | rest], beams, count) do
    {beams_to_split, beams_to_not_split} = MapSet.split_with(beams, fn e -> e in head_splitters end)

    new_beams = compute_new_beams(beams_to_split, beams_to_not_split)
    split_count = MapSet.size(beams_to_split)
    # dbg({head_splitters, beams, new_beams, split_count})
    count_splits(rest, new_beams, count + split_count)
  end

  def compute_new_beams(to_split, dont_split) do
    MapSet.union(
      MapSet.new(Enum.flat_map(to_split, fn b -> [b - 1, b + 1] end)),
      dont_split
    )
  end

  def count_paths([], counts) do
    counts
    |> Enum.map(fn {_i, c} -> c end)
    |> Enum.sum()
  end

  def count_paths([head_splitters | rest], counts) do
    new_counts = split_paths(head_splitters, counts)
    count_paths(rest, new_counts)
  end

  def split_paths(head_splitters, counts) do
    # [{6, 1}, {8, 1}, {9, 4}], [6, 8]
    # --> [{5, 1}, {7, 2}, {9, 5}]

    beams = MapSet.new(Map.keys(counts))
    {beams_to_split, beams_to_not_split} = MapSet.split_with(beams, fn e -> e in head_splitters end)

    split_counts =
      beams_to_split
      |> Enum.flat_map(fn b -> [{b - 1, Map.get(counts, b, 1)}, {b + 1, Map.get(counts, b, 1)}] end) # split
      # |> dbg()
      |> Enum.reduce(%{}, fn {b, c}, acc ->
        # dbg({b, c, acc})
        Map.update(acc, b, c, fn old_count -> old_count + c end)
      end) # combine counts

    counts
    |> Map.filter(fn {k, _v} -> k in beams_to_not_split end)
    |> Map.merge(split_counts, fn _k, v1, v2 -> v1 + v2 end)
  end
end
