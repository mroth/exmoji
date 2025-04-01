defmodule ScannerTest do
  use ExUnit.Case, async: true

  alias Exmoji.Scanner

  @case_exact "🚀"
  @case_multi "\u{0023}\u{FE0F}\u{20E3}"
  @case_variant "flying on my 🚀 to visit the 👾 people."
  @case_multivariant "first a \u{0023}\u{FE0F}\u{20E3} then a 🚀"
  @case_duplicates "flying my 🚀 to visit the 👾 people who have their own 🚀 omg!"
  @case_none "i like turtles"

  #
  # #scan
  #
  test ".scan - should find the proper EmojiChar from a single string char" do
    results = Scanner.scan(@case_exact)
    assert Enum.count(results) == 1
    assert Enum.at(results, 0).__struct__ == Exmoji.EmojiChar
    assert Enum.at(results, 0).name == "ROCKET"
  end

  test ".scan - should find the proper EmojiChar from a variant encoded char" do
    results = Scanner.scan(@case_multi)
    assert Enum.count(results) == 1
    assert Enum.at(results, 0).name == "HASH KEY"
  end

  test ".scan - should match multiple chars from within a string" do
    results = Scanner.scan(@case_variant)
    assert Enum.count(results) == 2
  end

  test ".scan - should return multiple matches in proper order" do
    results = Scanner.scan(@case_variant)
    assert Enum.at(results, 0).name == "ROCKET"
    assert Enum.at(results, 1).name == "ALIEN MONSTER"
  end

  test ".scan - should return multiple matches in proper order for variants" do
    results = Scanner.scan(@case_multivariant)
    assert Enum.count(results) == 2
    assert Enum.at(results, 0).name == "HASH KEY"
    assert Enum.at(results, 1).name == "ROCKET"
  end

  test ".scan - should return multiple matches including duplicates" do
    results = Scanner.scan(@case_duplicates)
    assert Enum.count(results) == 3
    assert Enum.at(results, 0).name == "ROCKET"
    assert Enum.at(results, 1).name == "ALIEN MONSTER"
    assert Enum.at(results, 2).name == "ROCKET"
  end

  test ".scan - returns and empty list if nothing is found" do
    assert Scanner.scan(@case_none) == []
  end

  #
  # #bscan
  #
  test ".bscan - make sure binary scan gets same result as legacy regex scan" do
    testcases = [
      @case_exact,
      @case_multi,
      @case_variant,
      @case_multivariant,
      @case_duplicates,
      @case_none
    ]

    for tc <- testcases, do: assert(Scanner.bscan(tc) == Scanner.rscan(tc))
  end
end
