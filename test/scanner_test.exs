defmodule ScannerTest do
  use ExUnit.Case, async: true

  alias Exmoji.Scanner

  #
  # #scan
  #
  test ".scan - should find the proper EmojiChar from a single string char" do
    results = Scanner.scan("🚀")
    assert Enum.count(results) == 1
    assert Enum.at(results,0).__struct__ == Exmoji.EmojiChar
    assert Enum.at(results,0).name == "ROCKET"
  end

  test ".scan - should find the proper EmojiChar from a variant encoded char" do
    results = Scanner.scan("\x{0023}\x{FE0F}\x{20E3}")
    assert Enum.count(results) == 1
    assert Enum.at(results,0).name == "HASH KEY"
  end

  test ".scan - should match multiple chars from within a string" do
    results = Scanner.scan("flying on my 🚀 to visit the 👾 people.")
    assert Enum.count(results) == 2
  end

  test ".scan - should return multiple matches in proper order" do
    results = Scanner.scan("flying on my 🚀 to visit the 👾 people.")
    assert Enum.at(results,0).name == "ROCKET"
    assert Enum.at(results,1).name == "ALIEN MONSTER"
  end

  test ".scan - should return multiple matches in proper order for variants" do
    results = Scanner.scan("first a \x{0023}\x{FE0F}\x{20E3} then a 🚀")
    assert Enum.count(results) == 2
    assert Enum.at(results,0).name == "HASH KEY"
    assert Enum.at(results,1).name == "ROCKET"
  end

  test ".scan - should return multiple matches including duplicates" do
    results = Scanner.scan("flying my 🚀 to visit the 👾 people who have their own 🚀 too.")
    assert Enum.count(results) == 3
    assert Enum.at(results,0).name == "ROCKET"
    assert Enum.at(results,1).name == "ALIEN MONSTER"
    assert Enum.at(results,2).name == "ROCKET"
  end

  test ".scan - returns and empty list if nothing is found" do
    assert Scanner.scan("i like turtles") == []
  end

end
