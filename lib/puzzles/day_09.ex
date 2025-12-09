defmodule Aoc2025.Day09 do
  def part_1(input) do
    data = parse_input(input)

    # IDEA
    # - Find 4 corner-most points
    # - These create 2 possible max rectangles
    # - Find the max area between the two

    # top_left = top_left_most(data)
    # top_right = top_right_most(data)
    # bottom_left = bottom_left_most(data)
    # bottom_right = bottom_right_most(data)

    # max(rectangle_area(top_left, bottom_right), rectangle_area(top_right, bottom_left))

    # Ok that didn't work for some reason
    # brute force lol

    data
    |> comb(2)
    |> Enum.map(fn [p1, p2] -> rectangle_area(p1, p2) end)
    |> Enum.max()
  end

  # Latest answer: 1482199650 (too low)
  def part_2(input) do
    data = parse_input(input)

    # IDEA
    # - Start the same way as part 1
    # - For the rectangle you want to choose: check if it is all red/green
    # - If not, try the next one, if so, return that answer
    #
    # all_red_or_green: ([point()], point(), point()) -> boolean()
    # - given data and corners
    # - does the drawn rectangle **cross** any known lines?
    # - let's say for now that the input is not set up in such a way where this could cause problems
    #
    # WISHLIST
    # type line() :: {point(), point()} s.t. x1 = x2 or y1 = y2
    # crosses: (line(), point(), point()) -> boolean()
    # - Does the line lie on the inside of the specified rectangle?
    #
    # Still gives wrong answer because can be on edge and totally outside
    # - what if we just limit the coordinates
    # - force p1 to have x < half and p2 to have x > half

    {{_p1, _p2, result}, _index} =
      data
      |> comb(2)
      |> Enum.map(fn [p1, p2] -> {p1, p2, rectangle_area(p1, p2)} end)
      |> Enum.sort(fn {_, _, s1}, {_, _, s2} -> s1 >= s2 end)
      |> Enum.with_index()
      |> Enum.find(fn {{p1, p2, _size}, _index} -> all_red_or_green(data, p1, p2) end)
      |> dbg()

    result
  end

  def all_red_or_green(data, p1, p2) do
    data
    |> windowed()
    |> Enum.all?(fn line ->
      result = !crosses(line, p1, p2)

      if !result do
        dbg({line, p1, p2})
      end

      result
      end)
  end

  def windowed(l), do: windowed(tl(l), hd(l), [{List.last(l), hd(l)}])
  def windowed([last], prev, acc), do: Enum.reverse([{prev, last} | acc])
  def windowed([head | rest], prev, acc), do: windowed(rest, head, [{prev, head} | acc])

  def crosses({{lx1, ly1}, {lx2, ly2}}, {cx1, cy1}, {cx2, cy2}) do
    # IDEA
    # Line crosses rectangle if
    # - it goes through and does not lie on the boundary
    # - which means if line is (x1, x2, y), p1_y < y < p2_y (assuming p1 top left and p2 bottom right)
    # - or (x, y1, y2) : p1_x < x < p2_x
    #
    # PROBLEM WAS: intersecting AT bottom border while not on L/R edge was saying yes, there is a cross.

    diff_cx = if cx1 > cx2, do: -1, else: 1
    diff_cy = if cy1 > cy2, do: -1, else: 1

    cond do
      ly1 == ly2 ->
        step_l = if lx1 > lx2, do: -1, else: 1
        step_c = if cx1 > cx2, do: -1, else: 1
        ((ly1 > cy1 && ly1 < cy2) || (ly1 > cy2 && ly1 < cy1)) && !Range.disjoint?(lx1..lx2//step_l, (cx1 + diff_cx)..(cx2 - diff_cy)//step_c)

      lx1 == lx2 ->
        step_l = if ly1 > ly2, do: -1, else: 1
        step_c = if cy1 > cy2, do: -1, else: 1
        ((lx1 > cx1 && lx1 < cx2) || (lx1 > cx2 && lx1 < cx1)) && !Range.disjoint?(ly1..ly2//step_l, (cy1 + diff_cy)..(cy2 - diff_cy)//step_c)

      true -> raise "invalid line case!"
    end
  end

  def parse_input(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn line ->
      [x, y] =
        line
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)

      {x, y}
    end)
  end

  def top_left_most(data), do: top_left_most(tl(data), hd(data))
  def top_left_most([], most), do: most
  def top_left_most([{head_x, head_y} | rest], {cur_x, cur_y}) when head_x <= cur_x and head_y <= cur_y, do: top_left_most(rest, {head_x, head_y})
  def top_left_most([_head | rest], cur), do: top_left_most(rest, cur)

  def top_right_most(data), do: top_right_most(tl(data), hd(data))
  def top_right_most([], most), do: most
  def top_right_most([{head_x, head_y} | rest], {cur_x, cur_y}) when head_x >= cur_x and head_y <= cur_y, do: top_right_most(rest, {head_x, head_y})
  def top_right_most([_head | rest], cur), do: top_right_most(rest, cur)

  def bottom_left_most(data), do: bottom_left_most(tl(data), hd(data))
  def bottom_left_most([], most), do: most
  def bottom_left_most([{head_x, head_y} | rest], {cur_x, cur_y}) when head_x <= cur_x and head_y >= cur_y, do: bottom_left_most(rest, {head_x, head_y})
  def bottom_left_most([_head | rest], cur), do: bottom_left_most(rest, cur)

  def bottom_right_most(data), do: bottom_right_most(tl(data), hd(data))
  def bottom_right_most([], most), do: most
  def bottom_right_most([{head_x, head_y} | rest], {cur_x, cur_y}) when head_x >= cur_x and head_y >= cur_y, do: bottom_right_most(rest, {head_x, head_y})
  def bottom_right_most([_head | rest], cur), do: bottom_right_most(rest, cur)

  def rectangle_area({x1, y1}, {x2, y2}) do
    (abs(x2 - x1) + 1) * (abs(y2 - y1) + 1)
  end

  # https://rosettacode.org/wiki/Combinations#Elixir
  def comb(_, 0), do: [[]]
  def comb([], _), do: []
  def comb([h|t], m) do
    (for l <- comb(t, m-1), do: [h|l]) ++ comb(t, m)
  end
end
