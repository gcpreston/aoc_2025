defmodule Aoc2025.Day10 do
  def part_1(input) do
    # IDEA
    # - Need only indicated indices to be activated, all others deactivated
    # - This is a state search tree that expands with a breadth of length(buttons)
    # - I wonder if it is better/any different to start at the activated state and find the off state
    #
    # PROBLEM: [.#.##...##] (0,1,7) (0,1,2,3,4,5,6,7,9) (1,4,5,8) (2,3,4) (2,4,5,6,9) (3,5) (0,1,3,4,9) (0,1,2,3,4,5,6,8,9) (0,1,2,6,8,9) (0,5,6) (1,2,3,4,5,6)
    # Found: depth 7
    #
    # Some optimization ideas
    # - this is essentially bitwise XOR
    # - XOR is commutative and associative
    # - We need to find some combination of buttons to press
    # - Pressing the same button twice NO MATTER WHERE IN THE PATTERN cancels it out
    # - SO every button is pressed either 0 or 1 times
    # - => for depth n, can check every combination of buttons and that's it

    goals = parse_input(input)

    goals
    |> Enum.map(fn {light_goal, buttons} -> find_goal(light_goal, buttons) end)
    |> Enum.sum()
  end

  def part_2(_input) do

  end

  def parse_input(input) do
    input
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    elements = String.split(line, " ")
    [lights_str | rest] = elements
    {button_strs, _unknwon} = Enum.split(rest, length(rest) - 1)
    {parse_lights(lights_str), Enum.map(button_strs, &parse_button/1)}
  end

  def parse_lights(lights_str) do
    lights_str
    |> String.slice(1..(String.length(lights_str) - 2))
    |> String.graphemes()
    |> find_indices("#")
    |> MapSet.new()
  end

  def parse_button(button_str) do
    button_str
    |> String.slice(1..(String.length(button_str) - 2))
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> MapSet.new()
  end

  def find_indices(l, to_find) do
    Enum.reduce(Enum.with_index(l), [], fn {e, i}, acc ->
      if e == to_find do
        [i | acc]
      else
        acc
      end
    end)
    |> Enum.reverse()
  end

  def press_button(lights, button), do: MapSet.symmetric_difference(lights, button)

  def press_buttons(lights, buttons) do
    Enum.reduce(buttons, lights, fn button, state -> press_button(state, button) end)
  end

  def find_goal(light_goal, buttons) do
    # check for depth 0, 1, ... until a comb is found
    find_goal(light_goal, buttons, 0)
  end

  def find_goal(light_goal, buttons, depth) do
    answer =
      buttons
      |> comb(depth)
      |> Enum.find(fn combo ->
        press_buttons(MapSet.new(), combo) == light_goal
      end)

    if answer == nil do
      find_goal(light_goal, buttons, depth + 1)
    else
      depth
    end
  end

    # https://rosettacode.org/wiki/Combinations#Elixir
  def comb(_, 0), do: [[]]
  def comb([], _), do: []
  def comb([h|t], m) do
    (for l <- comb(t, m-1), do: [h|l]) ++ comb(t, m)
  end
end
