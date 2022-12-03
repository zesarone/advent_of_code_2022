defmodule DayThree do
  def parseInput do
    {:ok, contents} = File.read("lib/daythree/input")

    contents
    |> String.split("\n", trim: true)
    |> Enum.map(fn a -> String.split(a, "") |> Enum.filter(&(&1 != "")) end)
  end

  def sumRedundantRagSackItemsA do
    parseInput()
    |> Enum.map(fn a -> redundantItems(a) |> Enum.map(&priority/1) |> Enum.sum() end)
    |> Enum.sum()
  end

  def redundantItems(sack) do
    {a, b} = Enum.split(sack, Kernel.floor(Enum.count(sack) / 2))

    MapSet.intersection(MapSet.new(a), MapSet.new(b))
    |> MapSet.to_list()
  end

  def priority(<<ascii>>) do
    cond do
      ascii >= 97 && ascii <= 122 -> ascii - 96
      ascii >= 65 && ascii <= 90 -> ascii - 38
    end
  end

  def sumGroupOfThreeRedundantItemB do
    parseInput()
    |> partitionSacks()
    |> Enum.map(fn a -> sacksIntersection(a) |> Enum.map(&priority/1) |> Enum.sum() end)
    |> Enum.sum()
  end

  def sacksIntersection({a, b, c}) do
    MapSet.intersection(MapSet.new(a), MapSet.new(b))
    |> MapSet.intersection(MapSet.new(c))
    |> MapSet.to_list()
  end

  def partitionSacks([]), do: []

  def partitionSacks([first, sec, third | rest]) do
    [{first, sec, third} | partitionSacks(rest)]
  end
end
