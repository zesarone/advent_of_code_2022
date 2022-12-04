defmodule Dayfour do
  @spec parseInput :: [[integer()]]
  defp parseInput do
    {:ok, contents} = File.read("lib/dayfour/input")

    contents
    |> String.split("\n", trim: true)
    |> Enum.map(&parsePair/1)
  end

  defp parsePair(pair) do
    String.split(pair, ",")
    |> Enum.map(fn interval ->
      [a, b] = String.split(interval, "-")
      {aa, _} = Integer.parse(a)
      {bb, _} = Integer.parse(b)
      aa..bb
    end)
  end

  @spec overlappingPairsA :: non_neg_integer
  @doc """
  iex Dayfour.overlappingPairsA
  580
  """
  def overlappingPairsA do
    parseInput()
    |> Enum.filter(&fullOverlap/1)
    |> Enum.count()
  end

  @spec fullOverlap([integer()]) :: boolean
  defp fullOverlap([a, b]) do
    MapSet.subset?(MapSet.new(a), MapSet.new(b)) ||
      MapSet.subset?(MapSet.new(b), MapSet.new(a))
  end

  @doc """
  iex> Dayfour.overlappingPairsB
  895
  """
  def overlappingPairsB do
    parseInput()
    |> Enum.filter(fn [a, b] -> not Range.disjoint?(a, b) end)
    |> Enum.count()
  end
end
