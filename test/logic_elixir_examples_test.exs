defmodule LogicElixirExamplesTest do
  use ExUnit.Case
  doctest LogicElixirExamples

  test "greets the world" do
    assert LogicElixirExamples.hello() == :world
  end
end
