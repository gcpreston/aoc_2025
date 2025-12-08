defmodule Aoc2025.Day08 do
  def part_1(input) do
    boxes = parse_input(input)

    # IDEA
    # - Create list of all combinations of vertices
    # - Map to {box1, box2, distance}
    # - Sort by distance ascending
    # - Take first 1000
    # - Count connected components
    # - Product of sizes of top 3 largest components
    #
    # Would be more efficient to combine some of these steps but I don't
    # believe it makes an overall time complexity difference, nbd.

    boxes
    |> comb(2)
    |> Enum.map(fn [box1, box2] -> {box1, box2, distance(box1, box2)} end)
    |> Enum.sort(fn {_, _, d1}, {_, _, d2} -> d1 <= d2 end)
    |> Enum.take(1000)
    |> connected_components()
    |> Enum.sort(fn comp1, comp2 -> MapSet.size(comp1) >= MapSet.size(comp2) end)
    |> Enum.take(3)
    |> Enum.map(&MapSet.size/1)
    |> Enum.product()
  end

  def part_2(input) do
    boxes = parse_input(input)

    # IDEA
    # - Enum.reduce_while until there is one connected component of size length(boxes)

    boxes
    |> comb(2)
    |> Enum.map(fn [box1, box2] -> {box1, box2, distance(box1, box2)} end)
    |> Enum.sort(fn {_, _, d1}, {_, _, d2} -> d1 <= d2 end)
    |> Enum.reduce_while([], fn pair, acc ->
      new_acc = connected_components([pair], acc)

      if length(new_acc) == 1 && MapSet.size(hd(new_acc)) == length(boxes) do
        {box1, box2, _} = pair
        [x1, _, _] = box1
        [x2, _, _] = box2
        {:halt, x1 * x2}
      else
        {:cont, new_acc}
      end
    end)
  end

  def parse_input(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn line ->
      line
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def distance(box1, box2) do
    :math.sqrt(
      [box1, box2]
      |> Enum.zip()
      |> Enum.map(fn {c1, c2} -> (c2 - c1) ** 2 end)
      |> Enum.sum()
    )
  end

  # https://rosettacode.org/wiki/Combinations#Elixir
  def comb(_, 0), do: [[]]
  def comb([], _), do: []
  def comb([h|t], m) do
    (for l <- comb(t, m-1), do: [h|l]) ++ comb(t, m)
  end

  def connected_components(l), do: connected_components(l, [])

  def connected_components([], acc), do: acc

  # IDEA
  # - Maintain list of disjoint sets
  # - for an edge between a and b:
  #   * find sets with either a or b inside
  #   * if there are 2, connect them
  #   * if there is 1, add both elements to set
  #   * if there are 0, make new set
  def connected_components([{a, b, _distance} | rest], acc) do
    new_acc =
      case Enum.split_with(acc, fn s -> a in s || b in s end) do
        {[set1, set2], others} -> [MapSet.union(set1, set2) | others]
        {[set1], others} -> [set1 |> MapSet.put(a) |> MapSet.put(b) | others]
        {[], others} -> [MapSet.new([a, b]) | others]
      end

    connected_components(rest, new_acc)
  end
end
