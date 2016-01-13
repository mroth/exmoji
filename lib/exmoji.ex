defmodule Exmoji do
  @moduledoc """
  An Elixir/Erlang library providing low level operations for dealing with Emoji
  glyphs in the Unicode standard.

  Exmoji is like a swiss-army knife for dealing with Emoji encoding issues. If
  all you need to do is translate `:poop:` into a smiling poop glyph, then there
  are plenty of other libs out there that will probably do what you want.  But
  once you are dealing with Emoji as a fundamental part of your application, and
  you start to realize the nightmare of doublebyte encoding or variants, then
  this library may be your new best friend.
  """

  alias Exmoji.EmojiChar

  #
  # Read and parse the Emoji library from our vendored data file.
  #
  vendor_data_file = "lib/vendor/emoji-data/emoji.json"
  @external_resource vendor_data_file

  rawfile = File.read! vendor_data_file
  rawdata = Poison.decode! rawfile, keys: :atoms
  emoji_chars = for char <- rawdata do
    %EmojiChar{
      name:         char.name,
      unified:      char.unified,
      variations:   char.variations,
      short_name:   char.short_name,
      short_names:  char.short_names,
      text:         char.text
    }
  end
  @emoji_chars emoji_chars


  @doc """
  Returns a list of all #{Enum.count @emoji_chars} Emoji characters as `EmojiChar`.
  """
  def all, do: @emoji_chars

  @doc """
  Returns a list of all `EmojiChar` that are represented as doublebyte encoding.
  """
  @all_doublebyte_cache Enum.filter(@emoji_chars, &EmojiChar.doublebyte?/1)
  def all_doublebyte, do: @all_doublebyte_cache

  @doc """
  Returns a list of all `EmojiChar` that have at least one variant encoding.
  """
  @all_variant_cache Enum.filter(@emoji_chars, &EmojiChar.variant?/1)
  def all_with_variants, do: @all_variant_cache


  @doc """
  Returns a list of all known Emoji characters rendered as Unicode bitstrings.

  By default, the default rendering options for this library will be used.
  However, if you pass the option of `include_variants: true` then all possible
  renderings of a single glyph will be included, meaning that:

  1. You will have "duplicate" emojis in your list.
  2. This list is now suitable for exhaustably matching against in a search.

  """
  def chars(opts \\ []) do
    case Keyword.get(opts, :include_variants, false) do
      false ->
        Enum.map(@emoji_chars, &EmojiChar.render/1)
      true ->
        Enum.map(@emoji_chars, &EmojiChar.chars/1)
        |> List.flatten
    end
  end


  @doc """
  Returns a list of all known codepoints representing Emoji characters.

  This function also accepts the `include_variants` option, for details on its
  significance, see similar discussion for the `Exmoji.chars/1` function.
  """
  def codepoints(opts \\ []) do
    case Keyword.get(opts, :include_variants, false) do
      false ->
        Enum.map(@emoji_chars, &(&1.unified))
      true ->
        Enum.map(@emoji_chars, &EmojiChar.codepoint_ids/1)
        |> List.flatten
    end
  end


  @doc """
  Finds any `EmojiChar` that contains given string in its official name.

  ## Examples

      iex> Exmoji.find_by_name "father"
      [%Exmoji.EmojiChar{name: "FATHER CHRISTMAS", short_name: "santa",
      short_names: ["santa"], text: nil, unified: "1F385", variations: []}]

      iex> for t <- Exmoji.find_by_name("tree"), do: t.name
      ["EVERGREEN TREE", "DECIDUOUS TREE", "PALM TREE", "CHRISTMAS TREE",
      "TANABATA TREE"]

  """
  def find_by_name(name) do
    name = String.upcase(name)
    Enum.filter( @emoji_chars, &(String.contains?(&1.name, name)) )
  end


  @doc """
  Find all `EmojiChar` that match substring in any of their associated short
  name keywords.
  """
  def find_by_short_name(sname) do
    target = String.downcase(sname)
    Enum.filter( @emoji_chars, &(matches_short_name(&1, target)) )
  end

  defp matches_short_name(%EmojiChar{} = ec, target) do
    Enum.any?( ec.short_names, &(String.contains?(&1, target)) )
  end


  @doc """
  Finds an `EmojiChar` based on its short name keyword.

  Case insensitive. Otherwise must match exactly. Do not include the `:colon:`
  identifiers if you are parsing text that uses them to indicate the presence of
  a keyword.
  """
  def from_short_name(sname) do
    sname |> String.downcase |> _from_short_name
  end

  for ec <- @emoji_chars, sn <- ec.short_names do
    defp _from_short_name( unquote(sn) ), do: unquote(Macro.escape(ec))
  end
  defp _from_short_name(_), do: nil


  @doc """
  Finds a specific `EmojiChar` based on the unified codepoint ID.
  """
  def from_unified(uid) do
    uid |> String.upcase |> _from_unified
  end

  for ec <- @emoji_chars, cp <- EmojiChar.codepoint_ids(ec) do
    defp _from_unified( unquote(cp) ), do: unquote(Macro.escape(ec))
  end
  defp _from_unified(_), do: nil


  @doc """
  Convert a unified ID directly to its bitstring glyph representation.

  ## Example

      iex> Exmoji.unified_to_char("1F47E")
      "👾"

  """
  def unified_to_char(uid) do
    uid
    |> String.split("-")
    |> Enum.map( &(String.to_integer(&1, 16)) )
    |> List.to_string
  end


  @doc """
  Convert a native bitstring glyph to its unified codepoint ID.

  This is a conversion operation, not a match, so it may produce unexpected
  results with different types of values.

  ## Examples

      iex> Exmoji.char_to_unified("👾")
      "1F47E"

      iex> Exmoji.char_to_unified("\x{23}\x{fe0f}\x{20e3}")
      "0023-FE0F-20E3"

  """
  def char_to_unified(char) do
    char
    |> String.codepoints
    |> Enum.map(&padded_hex_string/1)
    |> Enum.join("-")
    |> String.upcase
  end
  # produce a string representation of the integer value of a codepoint, in hex
  # this should be zero-padded to a minimum of 4 digits
  defp padded_hex_string(<< cp_int_value :: utf8 >>) do
    cp_int_value |> Integer.to_string(16) |> String.rjust(4,?0)
  end


end
