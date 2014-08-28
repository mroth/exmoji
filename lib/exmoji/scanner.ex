defmodule Exmoji.Scanner do
  @doc """
  Scans a string for all EmojiChars contained within.

  Returns a list of all EmojiChars contained within that string, in order.
  """
  def scan(str) do
    # rscan(str)
    bscan(str)
    |> Enum.map(&Exmoji.char_to_unified/1)
    |> Enum.map(&Exmoji.from_unified/1)
  end

  # regex scan, returns a list of emoji as char glyphs
  fbs_pattern = Exmoji.chars(include_variants: true) |> Enum.join("|")
  @fbs_regexp Regex.compile!( "(?:#{fbs_pattern})" )
  def rscan(str) do
    Regex.scan(@fbs_regexp, str)
    |> Enum.map(&List.first/1)
  end

  # recursive binary pattern match to do the same as above
  def bscan(str), do: _bscan(str, [])

  # make guarded functions to pattern match on all known glyphs at binary head.
  for glyph <- Exmoji.chars(include_variants: true) do
    defp _bscan(<< unquote(glyph), tail::binary >>, acc) do
      # if we match, add glyph to head of accumulator list and move on
      _bscan(tail, [unquote(glyph) | acc])
    end
  end
  # if nothing is found, cut the head off and move on
  defp _bscan(<< _head::utf8, tail::binary >>, acc), do: _bscan(tail, acc)
  # when we reach the end, return reversed accumulator
  defp _bscan(<<>>, acc), do: Enum.reverse(acc)

end
