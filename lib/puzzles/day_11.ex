defmodule Aoc2025.Day11 do

  defmodule Graph do
    use Memoize

    @type vertex() :: String.t()
    @type t() :: {[vertex()], %{vertex() => [vertex()]}}

    def new(), do: {[], %{}}

    # add_vertex and add_edges don't do validity/duplicate checks.

    def add_vertex({vertices, edges}, v), do: {[v | vertices], edges}

    def add_edge({vertices, edges}, v1, v2) do
      {vertices, Map.update(edges, v1, [v2], fn v1_edges -> [v2 | v1_edges] end)}
    end

    def add_edges(g, _v, []), do: g
    def add_edges(g, v1, [v2 | rest]), do: add_edges(add_edge(g, v1, v2), v1, rest)

    def neighbors({_vertices, edges}, v), do: Map.get(edges, v, [])

    def count_paths_between(g, v1, v2), do: count_paths_between(g, v2, [v1], 0)

    def count_paths_between(_g, _v2, [], total), do: total

    def count_paths_between(g, v2, [v | rest], total) do
      if v == v2 do
        count_paths_between(g, v2, rest, total + 1)
      else
        count_paths_between(g, v2, neighbors(g, v) ++ rest, total)
      end
    end

    defmemo count_paths_between_v2(g, v1, v2) do
      if v1 == v2 do
        1
      else
        neighbors(g, v1)
        |> Enum.map(fn n -> count_paths_between_v2(g, n, v2) end)
        |> Enum.sum()
      end
    end
  end

  def part_1(input) do
    # Assuming the graph is acyclic
    input
    |> parse_input()
    |> Graph.count_paths_between_v2("you", "out")
  end

  def part_2(input) do
    g = parse_input(input)

    svr_dac = Graph.count_paths_between_v2(g, "svr", "dac")
    svr_fft = Graph.count_paths_between_v2(g, "svr", "fft")
    dac_fft = Graph.count_paths_between_v2(g, "dac", "fft")
    fft_dac = Graph.count_paths_between_v2(g, "fft", "dac")
    dac_out = Graph.count_paths_between_v2(g, "dac", "out")
    fft_out = Graph.count_paths_between_v2(g, "fft", "out")

    (svr_dac * dac_fft * fft_out) + (svr_fft * fft_dac * dac_out)
  end

  @spec parse_input(String.t()) :: Graph.t()
  def parse_input(input) do
    input
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
    |> Enum.reduce(Graph.new(), fn {vertex, edges}, g ->
      g
      |> Graph.add_vertex(vertex)
      |> Graph.add_edges(vertex, edges)
    end)
  end

  def parse_line(line) do
    [v, e_str] = String.split(line, ": ")
    e = String.split(e_str, " ")
    {v, e}
  end
end
