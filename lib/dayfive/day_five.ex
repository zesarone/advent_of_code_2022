defmodule Dayfive do
  defp parseRow([]), do: []

  defp parseRow([item | rest]),
    do: [item |> String.replace("[", "") |> String.replace("]", "") | parseRow(rest)]

  def parseStacks do
    {:ok, contents} = File.read("lib/dayfive/input_stacks")

    [_nrs | stacks] =
      contents
      |> String.split("\n", trim: true)
      |> Enum.reverse()

    s =
      stacks
      |> Enum.map(fn row ->
        row |> String.replace("    ", " [ ]") |> String.split("] [", trim: true)
      end)
      |> Enum.map(&parseRow/1)
      |> Enum.reduce(%{}, fn row, s ->
        row
        |> Enum.with_index()
        |> Enum.reduce(s, fn {item, i}, s ->
          Map.put(s, i + 1, [item, Map.get(s, i + 1) || []])
        end)
      end)

    s
    |> Enum.map(fn {i, a} -> {i, a |> List.flatten() |> Enum.filter(&(&1 != " "))} end)
    |> Enum.into(%{})
  end

  @spec parseMove(binary) :: [integer, ...]
  def parseMove(move) do
    [a, fromto] =
      move
      |> String.replace("move ", "")
      |> String.split(" from ")

    [f, t] = fromto |> String.split(" to ")
    {amount, _} = Integer.parse(a)
    {from, _} = Integer.parse(f)
    {to, _} = Integer.parse(t)
    [amount, from, to]
  end

  @spec parseMoves :: [integer()]
  def parseMoves do
    {:ok, contents} = File.read("lib/dayfive/input_moves")

    contents
    |> String.split("\n", trim: true)
    |> Enum.map(&parseMove/1)
  end

  @doc """
  iex> Dayfive.a
  "FJSRQCFTN"
  """
  def a do
    stacks = parseStacks()
    moves = parseMoves()

    moves
    |> Enum.reduce(stacks, fn move, s ->
      performMove(s, move)
    end)
    |> Enum.map(fn {_, [h | _]} -> String.to_charlist(h) end)
    |> Enum.join()
  end

  def performMove(stacks, [amount, from, to]) do
    1..amount
    |> Enum.reduce(stacks, fn _, s -> s |> moveOne(from, to) end)
  end

  def moveOne(s, from, to) do
    [popped | f] = Map.get(s, from)
    t = [popped | Map.get(s, to)]
    Map.put(s, to, t) |> Map.put(from, f)
  end

  def moveMany(s, amount, from, to) do
    {to_move, f} =
      s
      |> Map.get(from)
      |> Enum.split(amount)

    t = to_move ++ Map.get(s, to)
    Map.put(s, to, t) |> Map.put(from, f)
  end

  @doc """
  iex> Dayfive.b
  "CJVLJQPHS"
  """
  def b do
    stacks = parseStacks()
    moves = parseMoves()

    moves
    |> Enum.reduce(stacks, fn [amount, from, to], s ->
      moveMany(s, amount, from, to)
    end)
    |> Enum.map(fn {_, [h | _]} -> String.to_charlist(h) end)
    |> Enum.join()
  end
end
