defmodule Exmoji.Scanner do
  @moduledoc """
  Provides fast searches against binary strings for the presence of UTF-8
  encoded Emoji characters.
  """

  @doc """
  Scans a bitstring for all encoded emoji characters contained within.

  Returns a list of all `EmojiChar` contained within that string, in order.

  ## Example

      iex> Exmoji.Scanner.scan("flying on my 🚀 to visit the 👾 people.")
      [%Exmoji.EmojiChar{name: "ROCKET", short_name: "rocket",
        short_names: ["rocket"], text: nil, unified: "1F680", variations: []},
       %Exmoji.EmojiChar{name: "ALIEN MONSTER", short_name: "space_invader",
        short_names: ["space_invader"], text: nil, unified: "1F47E", variations: []}]

  """
  def scan(str) do
    bscan(str)
    |> Enum.map(&Exmoji.char_to_unified/1)
    |> Enum.map(&Exmoji.from_unified/1)
  end

  # DEPRECATED: regex scan, returns a list of emoji as char glyphs
  #
  # Regular expressions are incredibly slow in Erlang, so this was replaced with
  # an efficient binary scan.  It remains here in the code for two reasons:
  #   a.) historical purposes and learning
  #   b.) since we still use this regex in the ruby and node versions of this
  #       library, this allows us to easily test and compare to make sure our
  #       new algorithm produces identical results.
  #
  # Thus it is kept as public so we can compare it in test...

  # fbs_pattern =
  #   Exmoji.chars(include_variants: true)
  #   |> Enum.map(fn emoji_char -> Regex.escape(emoji_char) end)
  #   |> Enum.join("|")
  # @fbs_regexp Regex.compile!( "(?:#{fbs_pattern})" )

  # @doc false
  # def rscan(str) do
  #   Regex.scan(@fbs_regexp, str)
  #   |> Enum.map(&List.first/1)
  # end

  # Binary pattern match scan to do the same as above!
  #
  # This looks deceptively simple, but before modifying it, bear in mind that
  # an EmojiChar rendered glyph can be represented as 1..3 utf8 codepoints in
  # sequence, and some of the longer sequences contain other sequences as
  # sub-sequences, so you want to always try to match longer sequences first, or
  # risk cutting a character in half.
  #
  # Essentially the logic here is:
  #   1. Make functions to pattern match on all known glyphs at binary head. We
  #      order these functions based on the bitsize of the pattern we will match
  #      against, to make sure we dont cut a character in half and get the small
  #      variant.
  #   2. If the function matches head of pattern (match), add glyph to head of
  #      our results accumulator and recurse on the remainder of the binary.
  #   3. If no pattern matches head of binary, chop of one utf8 segment and
  #      throw it away (non-match), recurse on the remainder of the binary.
  #   4. If end of the binary is reached, reverse the accumulator and return
  #      results!
  #
  @doc false
  def bscan(str), do: _bscan(str, [])

  # first we sort all known char glyphs by reverse bitsize, so we can use the
  # bigger binary patterns first when defining our pattern match functions.
  sorted_chars = Exmoji.chars(include_variants: true)
  |> Enum.sort( &(&1 > &2) )

  # define functions that pattern match against each emojichar binary at head.
  for glyph <- sorted_chars do
    defp _bscan(<< unquote(glyph), tail::binary >>, acc) do
      _bscan(tail, [unquote(glyph) | acc])
    end
  end
  # if nothing is found, cut the head off and move on.
  defp _bscan(<< _head::utf8, tail::binary >>, acc), do: _bscan(tail, acc)
  # when we reach the end, return reversed accumulator.
  defp _bscan(<<>>, acc), do: Enum.reverse(acc)

end
