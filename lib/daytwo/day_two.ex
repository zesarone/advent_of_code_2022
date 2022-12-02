defmodule Daytwo do
  @spec parseInput :: [[charlist()], ...]
  def parseInput do
    {:ok, contents} = File.read("lib/daytwo/input")

    contents
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, " "))
  end

  @spec sumPointsA :: number
  @doc """
  iex(1)> Daytwo.sumPointsA
    12276
  """
  def sumPointsA do
    parseInput()
    |> Enum.map(&matchPoint(&1))
    |> Enum.sum()
  end

  @spec matchPoint([<<_::8>>, ...]) :: 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9
  def matchPoint([a, b]) do
    opponent =
      case a do
        "A" -> 1
        "B" -> 2
        "C" -> 3
      end

    me =
      case b do
        "X" -> 1
        "Y" -> 2
        "Z" -> 3
      end

    cond do
      me == opponent ->
        3 + me

      (me == 1 && opponent == 3) || (me == 2 && opponent == 1) || (me == 3 && opponent == 2) ->
        6 + me

      true ->
        me
    end
  end

  @spec sumPointsB :: number
  @doc """
  iex(1)> Daytwo.sumPointsB
    9975
  """
  def sumPointsB do
    parseInput()
    |> Enum.map(&calcOutcomePoint(&1))
    |> Enum.sum()
  end

  @spec calcOutcomePoint([<<_::8>>, ...]) :: 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9
  def calcOutcomePoint([a, b]) do
    opponent =
      case a do
        "A" -> 1
        "B" -> 2
        "C" -> 3
      end

    case b do
      "X" ->
        cond do
          opponent == 1 -> 3
          opponent == 2 -> 1
          opponent == 3 -> 2
        end

      "Y" ->
        3 + opponent

      "Z" ->
        6 +
          cond do
            opponent == 1 -> 2
            opponent == 2 -> 3
            opponent == 3 -> 1
          end
    end
  end
end
