defmodule EmojiCharTest do
  use ExUnit.Case, async: true

  alias Exmoji.EmojiChar

  setup do
    invader   = %EmojiChar{unified: "1F47E"}
    usflag    = %EmojiChar{unified: "1F1FA-1F1F8"}
    hourglass = %EmojiChar{unified: "231B", variations: ["231B-FE0F"]}
    cloud     = %EmojiChar{unified: "2601", variations: ["2601-FE0F"]}
    {:ok, [invader: invader, usflag: usflag, hourglass: hourglass, cloud: cloud]}
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

  #
  # #doublebyte?
  #
  test "should know whether a char is doublebyte or not", examples do
    assert EmojiChar.doublebyte?(examples[:invader]) == false
    assert EmojiChar.doublebyte?(examples[:cloud])   == false
    assert EmojiChar.doublebyte?(examples[:usflag])  == true
  end

  #
  # #variant?
  #
  test "should know whether a char has variant encoding or not", examples do
    assert EmojiChar.variant?(examples[:hourglass]) == true
    assert EmojiChar.variant?(examples[:usflag]) == false
  end

  #
  # #variant
  #
  test "should return the most likely variant encoding ID representation", examples do
    assert EmojiChar.variant(examples[:hourglass]) == "231B-FE0F"
  end
  test "should return nil if there is no variant encoding for a char", examples do
    assert EmojiChar.variant(examples[:usflag]) == nil
  end

end
