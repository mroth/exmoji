defmodule EmojiCharTest do
  use ExUnit.Case, async: true

  alias Exmoji.EmojiChar

  setup do
    invader   = %EmojiChar{unified: '1F47E'}
    usflag    = %EmojiChar{unified: '1F1FA-1F1F8'}
    hourglass = %EmojiChar{unified: '231B', variations: ['231B-FE0F']}
    cloud     = %EmojiChar{unified: '2601', variations: ['2601-FE0F']}
    {:ok, [invader: invader, usflag: usflag, hourglass: hourglass, cloud: cloud]}
  end

  #
  # #render
  #
  test "should render a char as happy shiny unicode", %{invader: invader} do
    assert EmojiChar.render(invader) == "👾"
  end

  test "should render as happy shiny unicode for doublebyte chars", %{usflag: usflag} do
    assert EmojiChar.render(usflag) == "🇺🇸"
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

end
