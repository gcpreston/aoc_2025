defmodule Aoc2025.Day12 do
  def part_1(input) do
    # Some notes
    # - All shapes are upper bounded as 3x3
    # - Most basic case: if you have one shape left to place AND there is a
    #   3x3 empty space in the remaining grid, then a configuration is possible.
    # - Ways to put a shape: given a point: 4 rotations * 2 x flips (if asym. x) * 2 y flips (if asym. y) = 16
    # - There have to rules that say "if you theoretically could put the shape here and have it fit,
    #   you may as well put it here (i.e. next to another shape) instead"
    #
    # - This is never going to be like true puzzle piece fitting:
    #   There will never be a random filled space in the corner for example,
    #   where you have to fit a piece with the other pieces and with the 1x1 or 1x2 etc corner shape.
    #   It would always be another full piece in the corner, in which case it's like you were fitting
    #   the original on to the bigger shape in the center and THEN the one in the corner anyways.
    # - This is to say, the question can become "is there a way to fit these pieces together and
    #   /bound the width and height/ to x by y"
    #
    # - If there are ways to make exact rectangles, especially those with a dimension matching
    #   a region size, this just creates a smaller region and shrinks the problem
    # - Could try to compose rectangles for this
    # - Doesn't seem like this gives a general solution but might be a good idea
    #
    # - Maybe the approach is, try to come up with rectangles of a correct dimension with the min
    #   space wasted. We can try to say that if we can't make a layout with this, then we can't
    #   make it in any way, and then see where it fails.

    # 0: 5, 1: 6, 2: 7, 3: 7, 4: 7, 5: 7

    input
    |> parse_input()
    |> Enum.filter(fn {canvas, blocks} ->
      canvas_size(canvas) > blocks_to_use(blocks)
    end)
    |> length()
  end

  def part_2(input) do

  end

  def parse_input(input) do
    blocks = String.split(input, "\n\n")
    lines = List.last(blocks) |> String.split("\n")

    Enum.map(lines, &parse_line/1)
  end

  def parse_line(line) do
    [vars] = Regex.scan(~r/(\d+)x(\d+): (\d+) (\d+) (\d+) (\d+) (\d+) (\d+)/, line, capture: :all_but_first)

    [x, y, a, b, c, d, e, f] = Enum.map(vars, &String.to_integer/1)

    {{x, y}, {a, b, c, d, e, f}}
  end

  def blocks_to_use({a, b, c, d, e, f}) do
    (5 * a) + (6 * b) + (7 * c) + (7 * d) + (7 * e) + (7 * f)
  end

  def canvas_size({x, y}), do: x * y
end
