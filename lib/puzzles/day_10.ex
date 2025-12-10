defmodule Aoc2025.Day10 do
  def part_1(input) do
    # IDEA
    # - Need only indicated indices to be activated, all others deactivated
    # - This is a state search tree that expands with a breadth of length(buttons)
    # - I wonder if it is better/any different to start at the activated state and find the off state

    goals = parse_input(input)

    goals
    |> Enum.map(fn {light_goal, buttons} ->
      result = find_goal(light_goal, buttons)
      IO.puts("Goal found for #{inspect(light_goal)}: #{result}")
      result
    end)
    |> Enum.sum()
    |> dbg()
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

  def find_goal(light_goal, buttons) do
    lights_off = MapSet.new()
    q = :queue.from_list(Enum.map(buttons, fn button -> {press_button(lights_off, button), 1, MapSet.new([lights_off])} end))
    find_goal(light_goal, buttons, q)
  end

  def find_goal(light_goal, buttons, q) do
    case :queue.out(q) do
      {:empty, _q} ->
        raise "how did we even get here"

      {{:value, {light_state, depth, seen}}, q} ->
        cond do
          light_state == light_goal ->
            depth

          true ->
            new_additions = :queue.from_list(Enum.flat_map(buttons, fn button ->
              next_state = press_button(light_state, button)
              if next_state in seen do
                []
              else
                [{next_state, depth + 1, MapSet.put(seen, light_state)}]
              end
            end))
            new_q = :queue.join(q, new_additions)
            find_goal(light_goal, buttons, new_q)
        end
    end
  end
end
