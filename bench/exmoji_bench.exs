defmodule ExmojiBench do
  use Benchfella

  bench "all",                do: Exmoji.all
  bench "all_doublebyte",     do: Exmoji.all_doublebyte
  bench "all_with_variants",  do: Exmoji.all_with_variants
  bench "from_unified",       do: Exmoji.from_unified("1F680")
  bench "chars",              do: Exmoji.chars
  bench "codepoints",         do: Exmoji.codepoints

  bench "find_by_name - many", do: Exmoji.find_by_name("tree")
  bench "find_by_name - none", do: Exmoji.find_by_name("zzzz")

  bench "find_by_short_name - many", do: Exmoji.find_by_short_name("MOON")
  bench "find_by_short_name - none", do: Exmoji.find_by_short_name("zzzz")

  bench "char_to_unified - single", do: Exmoji.char_to_unified("🚀")
  bench "char_to_unified - double", do: Exmoji.char_to_unified("\x{2601}\x{FE0F}")

  bench "unified_to_char - single", do: Exmoji.unified_to_char("1F47E")
  bench "unified_to_char - double", do: Exmoji.unified_to_char("2764-fe0f")
  bench "unified_to_char - triple", do: Exmoji.unified_to_char("0030-FE0F-20E3")

end
