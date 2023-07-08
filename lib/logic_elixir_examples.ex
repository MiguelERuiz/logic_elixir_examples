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

  def characters do
    (findall X, do: character(X)) |> Enum.into([])
  end

  def characters_count do
    (findall X, do: character(X)) |> Enum.count
  end
end
