# Aoc2025

Advent of Code 2025 solutions. All puzzles and parts are solved.

## Setup

Test inputs can be found in the `test_input/` directory. Real inputs are expected to be in the `input/` directory, named as `01.txt`, `02.txt`, etc.

```bash
$ iex -S mix

iex(1)> Aoc2025.test_day(1)
{3, 6}
iex(2)> Aoc2025.run_day(1)
{"part 1 solution", "part 2 solution"}
```

## Dependencies

The only day with a dependency is day 10, which relies on HiGHS. On Mac, it can be installed with:

```bash
$ brew install highs
```
