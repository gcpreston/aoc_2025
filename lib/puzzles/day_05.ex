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
    # IDEA: build up an ordered list of disjoint sets
    # - Maintain list of disjoint sets
    # - Iterate over fresh ranges
    # - Find range of existing sets which have some overlap
    # - **merge** this range of ordered disjoint sets with the new one; replace
    # - to finish, sum element count of all ranges
    #
    # Overlap cases: (top is existing, bottom new)
    # #####
    #    ooooo
    #
    #    #####
    # ooooo
    #
    # #####  #####
    #   oooooooo
    #
    #  ## ## ###
    # ooooooooooo
    #
    # - Can be disjoint already
    # - Need to figure out if front and/or back overlap for edge ranges
    # - Front overlap :: new start < existing end
    #   => merged range start = existing start
    # - Back overlap :: new end > existing start
    #   => merged range end = existing end
    # - Non-overlap on one side => merged range start/end = new range start/end

    {ranges, _ids} = parse_input(input)

    Enum.reduce(ranges, [], fn range, ordered_disjoint_ranges ->
      result = add_to_disjoint_ranges(ordered_disjoint_ranges, range)
      # dbg({ordered_disjoint_ranges, range, result}, charlists: :as_lists)
      result
    end)
    |> Enum.map(&Range.size/1)
    |> Enum.sum()
    # |> dbg(charlists: :as_lists)
  end

  def add_to_disjoint_ranges([], new_range), do: [new_range]

  def add_to_disjoint_ranges(disjoint_ranges, new_range) do
    {under_ranges, overlapping_ranges, over_ranges} = find_overlap(disjoint_ranges, new_range)

    replaced_overlapping_range =
      if overlapping_ranges == [] do
        new_range
      else
        {overlap_start, overlap_end} = overlap_split(overlapping_ranges)
        new_start..new_end//1 = new_range

        # use largest parameters of overlapping ranges
        min(overlap_start, new_start)..max(overlap_end, new_end)
      end

    # dbg({under_ranges, replaced_overlapping_range, over_ranges})

    # re-construct disjoint range list
    under_ranges ++ [replaced_overlapping_range] ++ over_ranges
  end

  def find_overlap(disjoint_ranges, new_range), do: find_overlap(disjoint_ranges, new_range, {[], []})

  def find_overlap([], _new_range, {under_ranges, overlapping_ranges}), do: {Enum.reverse(under_ranges), Enum.reverse(overlapping_ranges), []}

  # cases to consider:
  # - new_start > head_end => add head to under and keep going
  # - new_end < head_start => break and set rest as over
  # - !range.disjoint? => add to overlapping and keep going

  def find_overlap([_head_start..head_end//1 = head | rest], new_start.._new_end//1 = new_range, {under_ranges, overlapping_ranges}) when new_start > head_end do
    # IO.puts("in keep going case :  head range #{inspect(head)} new range #{inspect(new_range)}")
    find_overlap(rest, new_range, {[head | under_ranges], overlapping_ranges})
  end

  def find_overlap([head_start.._head_end//1 = head | rest], _new_start..new_end//1, {under_ranges, overlapping_ranges}) when new_end < head_start do
    # IO.puts("in break case :  head range #{inspect(head)} new range #{inspect(new_range)}")
    {Enum.reverse(under_ranges), Enum.reverse(overlapping_ranges), [head | rest]}
  end

  def find_overlap([head_range | rest], new_range, {under_ranges, overlapping_ranges}) do
    # IO.puts("in the overlap case : head range #{inspect(head_range)} new range #{inspect(new_range)}")
    find_overlap(rest, new_range, {under_ranges, [head_range | overlapping_ranges]})
  end

  # BUG FOUND
  # [0..11, 12..27, 29..31, 34..45] + 27..33

  def overlap_split(overlapping_ranges) do
    start.._//1 = hd(overlapping_ranges)
    _..stop//1 = List.last(overlapping_ranges)
    {start, stop}
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
