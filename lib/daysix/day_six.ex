defmodule Daysix do
  def parseInput do
    {:ok, contents} = File.read("lib/daysix/input")

    contents
    |> String.split("", trim: true)
  end

  def a do
    parseInput()
    |> findFirstfourUnique(1)
  end

  def findFirstfourUnique([_a, _b, _c | []], _i), do: nil

  def findFirstfourUnique([a, b, c, d, e | rest], i) do
    if(a != b && a != c && a != d && b != c && b != d && c != d) do
      i + 3
    else
      findFirstfourUnique([b, c, d, e | rest], i + 1)
    end
  end

  def b do
    parseInput()
    |> findFirstFourTeenUnique(1)
  end

  def findFirstFourTeenUnique(list, i) do
    {fourteen, _} = Enum.split(list, 14)

    size = MapSet.new(fourteen) |> MapSet.size()

    if(size == 14) do
      i + 13
    else
      [_ | rest] = list
      findFirstFourTeenUnique(rest, i + 1)
    end
  end
end
