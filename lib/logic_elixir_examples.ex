defmodule LogicElixirExamples do
  @moduledoc """
  Documentation for `LogicElixirExamples`.
  """

  use LogicElixir

  # # Facts

  defpred character(:homer)
  defpred character(:marge)
  defpred character(:bart)
  defpred character(:lisa)
  defpred character(:maggie)

  defpred astronaut(:homer)

  defpred likes(:homer, :bowling)
  defpred likes(:marge, :painting)
  defpred likes(:bart, :skate)
  defpred likes(:lisa, :jazz)

  defpred age(:homer, 36)
  defpred age(:marge, 34)
  defpred age(:bart, 10)
  defpred age(:lisa, 8)
  defpred age(:maggie, 1)
  defpred age(:miguel, 29)

  defpred father_of(:homer, :bart)
  defpred father_of(:homer, :lisa)
  defpred father_of(:homer, :maggie)

  defpred mother_of(:marge, :bart)
  defpred mother_of(:marge, :lisa)
  defpred mother_of(:marge, :maggie)

  defpred music_genre(:jazz)
  defpred music_genre(:rock)
  defpred music_genre(:pop)
  defpred music_genre(:classic)

  # # # Rules

  defpred robot(X) do
    choice do
      X = :bender
    else
      X = :r2d2
    else
      X = :ultron
    end
  end

  defpred siblings(X, Y) do
    character(X)
    character(Y)
    father_of(Z, X)
    father_of(Z, Y)
    mother_of(T, X)
    mother_of(T, Y)
    @(X != Y)
  end

  defpred adult(X) do
    character(X)
    age(X, Y)
    @(Y > 18)
  end

  defpred p(X) do
    choice do
      X = 5
    else
      X = 7
    end
  end

  def add(x, y), do: x + y

  defpred equals(Z) do
    Z = add(3, 4)
  end

  # # Predicates list-related

  defpred take_elem([X], X, [])
  defpred take_elem([X| Xs], X, Xs)
  defpred take_elem([X| Xs], Y, [X| Ys]), do: take_elem(Xs, Y, Ys)

  defpred append([], Ys, Ys)
  defpred append([X|Xs], Ys, [X|Zs]) do
    append(Xs, Ys, Zs)
  end

  defpred is_sorted([])
  defpred is_sorted([X])
  defpred is_sorted([X | [Y | Ys]]) do
    @(X <= Y)
    is_sorted([Y | Ys])
  end

  # permutation(Xs, Zs) <->
	#		Zs es una lista que resulta de permutar los elementos de Xs
	# ?- permutation([1, 2], L)
	# L = [1, 2];
	# L = [2, 1]
  defpred permutation([], [])

  defpred permutation([T | H], X) do
    permutation(H, H1)
    append(L1, L2, H1)
    append(L1, [T], X1)
    append(X1, L2, X)
  end

	# permutation_sort(Xs, Zs) <->
	#   Zs es la lista que resulta de permutar Xs
	defpred permutation_sort(Xs, Zs) do
		permutation(Xs, Zs)
		@(sorted?(Zs))
	end

	def permutation_sort_fun(xs) do
		(findall Zs, do: permutation_sort(xs, Zs)) |> Enum.take(1)
	end

  def appends(l) do
    findall {L1, L2}, into: [], do: append(L1, L2, l)
  end

  defpred get_elem(X, [X | T])
  defpred get_elem(X, [H | Ys]), do: get_elem(X, Ys)

  # # Functions that use predicates and manipulate them

  def all_characters do
    (findall X, do: character(X))
  end

  def all_characters_into do
    (findall X, into: [], do: character(X))
  end

  def all_characters_into_raw do
    x1 = LogicElixir.VarBuilder.gen_var()
    character({:var, x1}).(%{})
    |> Stream.map(fn sol ->
      t = {:var, x1}
      LogicElixir.Defcore.groundify(sol, t)
    end)
  end

  def characters_with_surname do
    (findall X, do: character(X))
    |> Stream.map(&"#{Atom.to_string(&1)} simpson")
    |> Enum.into([])
  end

  def people_likes do
    (findall {X, Y}, into: [], do: likes(X, Y))
  end

  def adults do
    findall {Adult, Y}, into: %{}, do: (character(Adult);  age(Adult, Y))
      # (character(Adult);  age(Adult, Y))
      # @(Y > 18)
    # end
  end

  def ages do
    findall Age do
      age(C, Age)
    end
  end

  def music_lovers do
    (findall {X, Y}, into: %{}, do:
      (character(X);
      music_genre(Y);
      likes(X, Y))
    )
  end

  def specific_character do
    (findall :apu, do: character(:apu)) |> Enum.into([])
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

  def sorted?(xs) do
		xs |> Enum.zip(tl(xs)) |> Enum.all?(fn {x, y} -> x <= y end)
	end
end
