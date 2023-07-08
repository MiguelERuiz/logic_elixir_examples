defmodule LogicElixirExamples do
  @moduledoc """
  Documentation for `LogicElixirExamples`.
  """

  use LogicElixir


  defpred character(:homer)
  defpred character(:marge)
  defpred character(:bart)
  defpred character(:lisa)
  defpred character(:maggie)

  defpred father_of(:homer, :bart)
  defpred father_of(:homer, :lisa)
  defpred father_of(:homer, :maggie)

  defpred mother_of(:marge, :bart)
  defpred mother_of(:marge, :lisa)
  defpred mother_of(:marge, :maggie)

  defpred siblings(X, Y) do
    character(X)
    character(Y)
    father_of(Z, X)
    father_of(Z, Y)
    mother_of(T, X)
    mother_of(T, Y)
    @(X != Y)
  end

  def characters do
    (findall X, do: character(X)) |> Enum.into([])
  end

  def characters_count do
    (findall X, do: character(X)) |> Enum.count
  end

  def siblings?(x, y) do
    siblings({:ground, x}, {:ground, y}).(%{}) |> Enum.into([]) == [%{}]
  end

end
