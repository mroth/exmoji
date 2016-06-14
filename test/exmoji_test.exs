defmodule ExmojiTest do
  use ExUnit.Case, async: true
  doctest Exmoji

  # Define a number of known Emoji library characteristics.
  # We should expect to get this many from our data file.
  # This may be manually updated in the future as Emoji evolves.
  @known_chars      1300
  @known_doublebyte 287
  @known_variants   134


  #
  # #all
  #
  test ".all - all #{@known_chars} emoji characters should be present" do
    assert Exmoji.all |> Enum.count == @known_chars
  end

  test ".all_doublebyte - convenience method for all doublebyte chars" do
    assert Exmoji.all_doublebyte |> Enum.count == @known_doublebyte
  end

  test ".all_with_variants - convenience method for all variant chars" do
    assert Exmoji.all_with_variants |> Enum.count == @known_variants
  end


  #
  # #chars
  #
  test ".chars - should return an array of all chars in unicode string format" do
    assert is_list(Exmoji.chars)
    assert Enum.all?(Exmoji.chars, fn c -> is_bitstring(c) end)
  end

  test ".chars - should by default return one entry per known EmojiChar" do
    assert Enum.count(Exmoji.chars) == @known_chars
  end

  test ".chars - should include variants in list when options {include_variants: true}" do
    assert Exmoji.chars(include_variants: true) |> Enum.count == @known_chars + @known_variants
  end

  test ".chars - should not have any duplicates in list when variants are included" do
    results = Exmoji.chars(include_variants: true)
    assert Enum.count(results) == Enum.count(Enum.uniq(results))
  end


  #
  # #codepoints
  #
  test ".codepoints - returns list of all codepoints in dashed string representation" do
    results = Exmoji.codepoints()
    assert Enum.count(results) == @known_chars
    for r <- results do
      assert String.match? r, ~r/^[0-9A-F\-]{4,42}$/
    end
  end

  test ".codepoints - include variants in list when options {include_variants: true}" do
    results = Exmoji.codepoints(include_variants: true)
    assert Enum.count(results) == @known_chars + @known_variants
    for r <- results do
      assert String.match? r, ~r/^[0-9A-F\-]{4,42}$/
    end
  end


  #
  # #from_unified
  #
  test ".from_unified - should find the proper EmojiChar object" do
    results = Exmoji.from_unified("1F680")
    assert results.name == "ROCKET"
  end

  test ".from_unified - should normalise capitalization for hex values" do
    assert Exmoji.from_unified("1f680") == Exmoji.from_unified("1F680")
  end

  test ".from_unified - should find via variant encoding ID format as well" do
    assert Exmoji.from_unified("2764-fe0f").name == "HEAVY BLACK HEART"
  end

  test ".from_unified - should return nil if there is no match" do
    assert Exmoji.from_unified("tacotacotaco") == nil
  end


  #
  # #find_by_name
  #
  test ".find_by_name - returns an array of results, upcasing input if needed" do
    results = Exmoji.find_by_name("tree")
    assert is_list(results)
    assert results |> Enum.count == 5
  end

  test ".find_by_name - returns empty list of no matches are found" do
    assert Exmoji.find_by_name("sdlkfjlskdfj") == []
  end


  #
  # #find_by_short_name
  #
  test ".find_by_short_name - returns a list of results, downcasing input if needed" do
    results = Exmoji.find_by_short_name("MOON")
    assert is_list(results)
    assert results |> Enum.count == 13
  end

  test ".find_by_short_name - returns empty list of no matches are found" do
    assert Exmoji.find_by_short_name("sdlkfjlskdfj") == []
  end


  #
  # #from_short_name
  #
  test ".from_short_name - returns exact matches on a short name" do
    results = Exmoji.from_short_name("scream")
    assert %Exmoji.EmojiChar{name: "FACE SCREAMING IN FEAR"} = results
  end

  test ".from_short_name - handles lowercasing input if required" do
    assert Exmoji.from_short_name("SCREAM") == Exmoji.from_short_name("scream")
  end

  test ".from_short_name - works on secondary keywords" do
    assert Exmoji.from_short_name("poop") == Exmoji.from_short_name("hankey")
    assert Exmoji.from_short_name("shit") == Exmoji.from_short_name("hankey")
  end

  test ".from_short_name - returns nil if nothing matches" do
    assert Exmoji.from_short_name("nacho") == nil
  end


  #
  # #char_to_unified
  #
  test ".char_to_unified - converts normal emoji to unified codepoint" do
    assert Exmoji.char_to_unified("👾") == "1F47E"
    assert Exmoji.char_to_unified("🚀") == "1F680"
  end

  test ".char_to_unified - converts double-byte emoji to proper codepoint" do
    assert Exmoji.char_to_unified("🇺🇸") == "1F1FA-1F1F8"
  end

  test ".char_to_unified - in doublebyte, adds padding to hex codes that are <4 chars" do
    assert Exmoji.char_to_unified("#⃣") == "0023-20E3"
  end

  test ".char_to_unified - converts variant encoded emoji to variant unified codepoint" do
    assert Exmoji.char_to_unified("\x{2601}\x{FE0F}") == "2601-FE0F"
  end


  #
  # #unified_to_char
  #
  test ".unified_to_char - converts normal unified codepoints to unicode strings" do
    assert Exmoji.unified_to_char("1F47E") == "👾"
    assert Exmoji.unified_to_char("1F680") == "🚀"
  end

  test ".unified_to_char - converts doublebyte unified codepoints to unicode strings" do
    assert Exmoji.unified_to_char("1F1FA-1F1F8") == "🇺🇸"
    assert Exmoji.unified_to_char("0023-20E3") == "#⃣"
  end

  test ".unified_to_char - converts variant unified codepoints to unicode strings" do
    assert Exmoji.unified_to_char("2764-fe0f") == "\x{2764}\x{FE0F}"
  end

  test ".unified_to_char - converts variant+doublebyte chars (triplets!) to unicode strings" do
    assert Exmoji.unified_to_char("0030-FE0F-20E3") == "\x{0030}\x{FE0F}\x{20E3}"
  end

end
