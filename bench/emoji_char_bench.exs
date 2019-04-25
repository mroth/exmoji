defmodule EmojiCharBench do
  use Benchfella

  alias Exmoji.EmojiChar

  @invader   %EmojiChar{unified: "1F47E"}
  @usflag    %EmojiChar{unified: "1F1FA-1F1F8"}
  @hourglass %EmojiChar{unified: "231B-FE0F", non_qualified: "231B"}
  @cloud     %EmojiChar{unified: "2601-FE0F", non_qualified: "2601"}

  bench "render - single",  do: EmojiChar.render(@invader)
  bench "render - double",  do: EmojiChar.render(@usflag)
  bench "render - variant", do: EmojiChar.render(@cloud, variant_encoding: true)

  bench "chars",       do: EmojiChar.chars(@cloud)
  bench "doublebyte?", do: EmojiChar.doublebyte?(@invader)
  bench "variant?",    do: EmojiChar.variant?(@invader)
  bench "variant",     do: EmojiChar.variant(@invader)

end
