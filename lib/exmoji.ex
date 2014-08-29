defmodule Exmoji do

  alias Exmoji.EmojiChar

  #
  # Read and parse the Emoji library from our vendored data file.
  #
  vendor_data_file = "vendor/emoji-data/emoji.json"
  @external_resource vendor_data_file

  rawfile = File.read!(vendor_data_file)
  rawdata = Jazz.Decode.it! rawfile, keys: :atoms
  emoji_chars = for char <- rawdata do
    %EmojiChar{
      name: char.name,
      unified: char.unified,
      variations: char.variations,
      short_name: char.short_name,
      short_names: char.short_names,
      text: char.text
    }
  end
  @emoji_chars emoji_chars

  @doc """
  Returns a list of all #{Enum.count @emoji_chars} Emoji characters
  """
  def all, do: @emoji_chars

  @doc """
  Returns a list of all EmojiChars that are represented as doublebyte encoding.
  """
  def all_doublebyte do
    Enum.filter @emoji_chars, &EmojiChar.doublebyte?/1
  end

  @doc """
  Returns a list of all EmojiChars that have at least one variant encoding.
  """
  def all_with_variants do
    Enum.filter @emoji_chars, &EmojiChar.variant?/1
  end


  @doc """
  Returns a list of all known emoji chars rendered as Unicode bitstrings.

  By default, the default rendering options for this library will be used.
  However, if you pass the option of `include_variants: true` then all possible
  renderings of a single glyph will be included, meaning that:

    1. you will have "duplicate" emojis in your list
    2. this list is now suitable for exhaustably matching against

  """
  def chars, do: chars(include_variants: false)
  def chars(include_variants: false) do
    Enum.map(@emoji_chars, &EmojiChar.render/1)
  end
  def chars(include_variants: true) do
    Enum.map(@emoji_chars, &EmojiChar.chars/1)
    |> List.flatten
  end


  # for char <- @emoji_chars do
  #   def find_by_n(unquote(char.name)), do: char
  # end
  def find_by_name(name) do
    @emoji_chars |> Enum.filter fn x -> String.contains? x.name, String.upcase(name) end
  end

  @doc """
  Finds an EmojiChar based on the unified codepoint ID.
  """
  def from_unified(uid) do
    uid |> String.upcase |> _from_unified
  end

  for ec <- @emoji_chars do
    defp _from_unified( unquote(ec.unified) ), do: unquote(Macro.escape(ec))
    for variant <- ec.variations do
      defp _from_unified( unquote(variant) ), do: unquote(Macro.escape(ec))
    end
  end

  @doc """
  Convert a unified ID directly to its bitstring glyph representation.
  """
  def unified_to_char(uid) do
    uid
    |> String.split("-")
    |> Enum.map( &(String.to_integer(&1, 16)) )
    |> List.to_string
  end

  @doc """
  Convert a native bitstring glyph to a unified ID.

  This is a conversion operation, not a match, so it may produce unexpected
  results with different types of values.

  ## Example

    iex> Exmoji.char_to_unified("👾")
    "1F47E"

  """
  def char_to_unified(char) do
    char
    |> String.codepoints
    |> Enum.map(&padded_hex_string/1)
    |> Enum.join("-")
    |> String.upcase
  end
  defp padded_hex_string(codepoint) do
    << cp_int_value :: utf8 >> = codepoint
    cp_int_value |> Integer.to_string(16) |> String.rjust(4,?0)
  end


end
