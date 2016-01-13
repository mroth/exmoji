defmodule Exmoji.EmojiChar do
  @moduledoc """
  EmojiChar is a struct represents a single Emoji character and its associated
  metadata.

  ## Fields

  * `name` - The standardized name used in the Unicode specification to
    represent this emoji character.
  * `unified` - The primary unified codepoint ID for the emoji.
  * `variations` - A list of all variant codepoints that may also represent this
    emoji.
  * `short_name` - The canonical "short name" or keyword used in many systems to
    refer to this emoji. Often surrounded by `:colons:` in systems like GitHub
    & Campfire.
  * `short_names` - A full list of possible keywords for the emoji.
  * `text` - An alternate textual representation of the emoji, for example a
    smiley face emoji may be represented with an ASCII alternative. Most emoji
    do not have a text alternative. This is typically used when building an
    automatic translation from typed emoticons.

  It also contains a few helper functions to deal with this data type.
  """

  defstruct [
    name: nil,
    unified: nil,
    variations: [],
    short_name: nil,
    short_names: [],
    text: nil
  ]

  alias Exmoji.EmojiChar

  @doc """
  Renders an `EmojiChar` to its bitstring glyph representation, suitable for
  printing to screen.

  By passing options field `variant_encoding` you can manually specify whether
  the variant encoding selector should be used to hint to rendering devices
  that "graphic" representation should be used. By default, we use this for all
  Emoji characters that contain a possible variant.
  """
  def render(ec, options \\ [variant_encoding: true])
  def render(ec, variant_encoding: false) do
    Exmoji.unified_to_char(ec.unified)
  end
  def render(ec, variant_encoding: true) do
    case variant?(ec) do
      true  -> Exmoji.unified_to_char( variant(ec) )
      false -> Exmoji.unified_to_char( ec.unified )
    end
  end

  defimpl String.Chars do
    def to_string(ec), do: EmojiChar.render(ec)
  end

  @doc """
  Returns a list of all possible bitstring renderings of an `EmojiChar`.

  E.g., normal, with variant selectors, etc. This is useful if you want to have
  all possible values to match against when searching for the emoji in a string
  representation.
  """
  def chars(%EmojiChar{}=emojichar) do
    codepoint_ids(emojichar)
    |> Enum.map(&Exmoji.unified_to_char/1)
  end

  @doc """
  Returns a list of all possible codepoint string IDs of an `EmojiChar`.

  E.g., normal, with variant selectors, etc. This is useful if you want to have
  all possible values to match against.

  ## Example

      iex> Exmoji.from_short_name("cloud") |> Exmoji.EmojiChar.codepoint_ids
      ["2601","2601-FE0F"]

  """
  def codepoint_ids(%EmojiChar{unified: uid, variations: variations}) do
    [uid] ++ variations
  end

  @doc """
  Is the `EmojiChar` represented by a doublebyte codepoint in Unicode?
  """
  def doublebyte?(%EmojiChar{unified: id}) do
    id |> String.contains?("-")
  end

  @doc """
  Does the `EmojiChar` have an alternate Unicode variant encoding?
  """
  def variant?(%EmojiChar{variations: variations}) do
    length(variations) > 0
  end

  @doc """
  Returns the most likely variant-encoding codepoint ID for an `EmojiChar`.

  For now we only know of one possible variant encoding for certain characters,
  but there could be others in the future.

  This is typically used to force Emoji rendering for characters that could be
  represented in standard font glyphs on certain operating systems.

  The resulting encoded string will be two codepoints, or three codepoints for
  doublebyte Emoji characters.

  If there is no variant-encoding for a character, returns nil.
  """
  def variant(%EmojiChar{variations: variations}) do
    List.first variations
  end

end
