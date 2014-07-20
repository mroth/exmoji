defmodule ExmojiTest do
  use ExUnit.Case, async: true
  doctest Exmoji

  alias Exmoji.EmojiChar

  # Define a number of known Emoji library characteristics.
  # We should expect to get this many from our data file.
  # This may be manually updated in the future as Emoji evolves.
  @known_chars      845
  @known_doublebyte 21
  @known_variants   107

  test "all #{@known_chars} emoji characters should be present" do
    assert Exmoji.all |> Enum.count == @known_chars
  end

  test "number of doublebyte charcters should match expected" do
    assert Exmoji.all
            |> Enum.count(&EmojiChar.doublebyte?(&1))
            == @known_doublebyte
  end

  test "number of characters with variant encoding should match expected" do
    assert Exmoji.all
            |> Enum.count(&EmojiChar.variant?(&1))
            == @known_variants
  end

end
