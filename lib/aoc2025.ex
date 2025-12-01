defmodule Aoc2025 do
  @moduledoc """
  Documentation for `Aoc2025`.
  """

  @input_directory "input"

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
  end
end
