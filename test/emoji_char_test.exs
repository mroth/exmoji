defmodule EmojiCharTest do
  use ExUnit.Case, async: true

  alias Exmoji.EmojiChar

  setup do
    invader = %EmojiChar{unified: "1F47E"}
    usflag = %EmojiChar{unified: "1F1FA-1F1F8"}
    hourglass = %EmojiChar{unified: "231B", variations: ["231B-FE0F"]}
    cloud = %EmojiChar{unified: "2601", variations: ["2601-FE0F"]}
    hash = %EmojiChar{unified: "0023-20E3", variations: ["0023-FE0F-20E3"]}
    {:ok, [invader: invader, usflag: usflag, hourglass: hourglass, cloud: cloud, hash: hash]}
  end

  #
  # #String.Chars - to_string
  #
  test "implements String.Chars", examples do
    assert "#{examples[:usflag]}" == EmojiChar.render(examples[:usflag])
  end

  #
  # #render
  #
  test ".render - should render a char as happy shiny unicode", examples do
    assert EmojiChar.render(examples[:invader]) == "👾"
  end

  test ".render - should render as happy shiny unicode for doublebyte chars", examples do
    assert EmojiChar.render(examples[:usflag]) == "🇺🇸"
  end

  test ".render - should have flag to output forced emoji variant char encoding if requested",
       examples do
    assert EmojiChar.render(examples[:cloud], variant_encoding: false) == "\u2601"
    assert EmojiChar.render(examples[:cloud], variant_encoding: true) == "\u2601\uFE0F"
  end

  test ".render - should fall back to normal encoding if no variant exists, even when requested",
       examples do
    assert EmojiChar.render(examples[:invader], variant_encoding: false) == "\u{1F47E}"
    assert EmojiChar.render(examples[:invader], variant_encoding: true) == "\u{1F47E}"
  end

  test ".render - should default to variant encoding for chars with a variant present",
       examples do
    assert EmojiChar.render(examples[:cloud]) == "\u2601\uFE0F"
    assert EmojiChar.render(examples[:hourglass]) == "\u231B\uFE0F"
  end

  #
  # # chars - all possible renderings for a glyph
  #
  test ".chars - should return an array of all possible string render variations", examples do
    assert EmojiChar.chars(examples[:invader]) == ["👾"]
    assert EmojiChar.chars(examples[:cloud]) == ["\u2601", "\u2601\uFE0F"]
  end

  #
  # # codepoints - all possible unified codepoint IDs for an EmojiChar
  #
  test ".codepoints - should return an array of all possible codepoint variations", examples do
    assert EmojiChar.codepoint_ids(examples[:invader]) == ["1F47E"]
    assert EmojiChar.codepoint_ids(examples[:cloud]) == ["2601", "2601-FE0F"]
    assert EmojiChar.codepoint_ids(examples[:hash]) == ["0023-20E3", "0023-FE0F-20E3"]
  end

  #
  # #doublebyte?
  #
  test ".doublebyte? - should know whether a char is doublebyte or not", examples do
    assert EmojiChar.doublebyte?(examples[:invader]) == false
    assert EmojiChar.doublebyte?(examples[:cloud]) == false
    assert EmojiChar.doublebyte?(examples[:usflag]) == true
  end

  #
  # #variant?
  #
  test ".variant? - should know whether a char has variant encoding or not", examples do
    assert EmojiChar.variant?(examples[:hourglass]) == true
    assert EmojiChar.variant?(examples[:usflag]) == false
  end

  #
  # #variant
  #
  test ".variant - should return the most likely variant encoding ID representation", examples do
    assert EmojiChar.variant(examples[:hourglass]) == "231B-FE0F"
  end

  test ".variant - should return nil if there is no variant encoding for a char", examples do
    assert EmojiChar.variant(examples[:usflag]) == nil
  end
end
