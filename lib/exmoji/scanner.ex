defmodule Exmoji.Scanner do
  # Create the regex matcher for scan as a precompiled module attribute.
  # In order to do this at compile time we need it to be it's own module.

  fbs_pattern = Exmoji.chars(include_variants: true) |> Enum.join("|")
  @fbs_regexp Regex.compile!( "(?:#{fbs_pattern})" )

  @doc """
  Scans a string for all EmojiChars contained within.

  Returns a list of all EmojiChars contained within that string, in order.
  """
  def scan(str) do
    Regex.scan(@fbs_regexp, str)
    |> Enum.map(&List.first/1)
    |> Enum.map(&Exmoji.char_to_unified/1)
    |> Enum.map(&Exmoji.find_by_unified/1)
  end

end
