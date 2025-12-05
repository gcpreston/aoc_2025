defmodule Aoc2025 do
  @moduledoc """
  Documentation for `Aoc2025`.
  """

  @input_directory "input"
  @test_input_directory "test_input"

  @doc """
  Read the entire input file for a day. Raises `File.Error`
  if file does not exist.

  ## Examples

      iex> Aoc2025.input_for_day(1)
      "..."

      iex> Aoc2025.input_for_day(26)
      ** (File.Error) could not read file "input/26.txt": no such file or directory

  """
  @spec input_for_day(integer()) :: String.t()
  def input_for_day(day) do
    Path.join([@input_directory, String.pad_leading("#{day}.txt", 6, "0")])
    |> File.read!()
    |> String.trim()
  end

  def test_input(file_name) do
    Path.join([@test_input_directory, file_name])
    |> File.read!()
    |> String.trim()
  end

  def run_day(day) do
    module =
      "Elixir.Aoc2025.Day#{String.pad_leading("#{day}", 2, "0")}"
      |> String.to_existing_atom()

    input = input_for_day(day)
    part_1_result = apply(module, :part_1, [input])
    part_2_result = apply(module, :part_2, [input])

    {part_1_result, part_2_result}
  end

  def test_day(day) do
    padded_day = String.pad_leading("#{day}", 2, "0")

    module =
      "Elixir.Aoc2025.Day#{padded_day}"
      |> String.to_existing_atom()

    input = test_input("#{padded_day}.txt")
    part_1_result = apply(module, :part_1, [input])
    part_2_result = apply(module, :part_2, [input])

    {part_1_result, part_2_result}
  end
end
