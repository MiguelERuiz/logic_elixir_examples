defmodule LogicElixirExamples do
  @moduledoc """
  Documentation for `LogicElixirExamples`.
  """

  use LogicElixir

  # Facts

  defpred character(:homer), do: @(IO.puts("Woo-hoo!"))
  defpred character(:marge)
  defpred character(:bart)
  defpred character(:lisa)
  defpred character(:maggie) do
    @(true)
  end

  defpred likes(:homer, :beer)
  defpred likes(:marge, :painting)
  defpred likes(:bart, :skate)
  defpred likes(:lisa, :jazz)

  defpred father_of(:homer, :bart)
  defpred father_of(:homer, :lisa)
  defpred father_of(:homer, :maggie)

  defpred mother_of(:marge, :bart)
  defpred mother_of(:marge, :lisa)
  defpred mother_of(:marge, :maggie)

  # Rules

  defpred siblings(X, Y) do
    character(X)
    character(Y)
    father_of(Z, X)
    father_of(Z, Y)
    mother_of(T, X)
    mother_of(T, Y)
    @(X != Y)
  end

  defpred p(X) do
    choice do
      X = 5
    else
      X = 7
    end
  end

  def all_ps do
    (findall X, do: p(X)) |> Enum.into([])
  end

  # Predicates list-related

  defpred is_sorted([])
  defpred is_sorted([X])
  defpred is_sorted([X | [Y | Ys]]) do
    @(X <= Y)
    is_sorted([Y | Ys])
  end

  defpred take_elem([X], X, [])
  defpred take_elem([X| Xs], X, Xs)
  defpred take_elem([X| Xs], Y, [X| Ys]), do: take_elem(Xs, Y, Ys)

  defpred append([], Ys, Ys)

  defpred append([X|Xs], Ys, [X|Zs]) do
    append(Xs, Ys, Zs)
  end

  defpred permutation([], [])

  defpred permutation([T | H], X) do
    permutation(H, H1)
    append(L1, L2, H1)
    append(L1, [T], X1)
    append(X1, L2, X)
  end

  defpred get_elem(X, [X | T])
  defpred get_elem(X, [H | Ys]), do: get_elem(X, Ys)

  # Functions that use predicates and manipulate them

  def all_characters do
    (findall X, do: character(X))
  end

  def characters_count do
    all_characters() |> Enum.count
  end

  def is_member?(character) do
    all_characters() |> Enum.member?(character)
  end

  def siblings?(x, y) do
    siblings({:ground, x}, {:ground, y}).(%{}) |> Enum.into([]) == [%{}]
  end

  def likes do
    (findall {X, Y}, do: likes(X, Y)) |> Enum.into([])
  end

end
