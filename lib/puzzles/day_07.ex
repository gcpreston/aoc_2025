defmodule Aoc2025.Day07 do
  @type pos() :: {integer(), integer()}
  @type data() :: {integer(), [MapSet.t(integer())]} # {start col, splitters}

  def part_1(input) do
    {start, splitters} = parse_input(input)
    count_splits(splitters, MapSet.new([start]), 0)
  end

  def part_2(input) do

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

    if MapSet.size(beams_to_split) == 0 do
      count_splits(rest, beams, count)
    else
      new_beams = compute_new_beams(beams_to_split, beams_to_not_split)
      split_count = MapSet.size(beams_to_split)
      # dbg({head_splitters, beams, new_beams, split_count})
      count_splits(rest, new_beams, count + split_count)
    end
  end

  def compute_new_beams(to_split, dont_split) do
    MapSet.union(
      MapSet.new(Enum.flat_map(to_split, fn b -> [b - 1, b + 1] end)),
      dont_split
    )
  end
end
