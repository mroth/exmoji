defmodule Exmoji.EmojiChar do
  defstruct(
    name: nil,
    unified: nil,
    variations: [],
    short_name: nil,
    short_names: [],
    text: nil
  )

  alias Exmoji.EmojiChar

  @doc """
  Renders an EmojiChar to its bitstring glyph representation, suitable for
  printing to screen.
  """
  def render(ec, options \\ [variant_encoding: true])
  def render(ec, variant_encoding: false) do
    Exmoji.unified_to_char(ec.unified)
  end
  def render(ec, variant_encoding: true) do
    case EmojiChar.variant?(ec) do
      true  -> Exmoji.unified_to_char( EmojiChar.variant(ec) )
      false -> Exmoji.unified_to_char( ec.unified )
    end
  end

  @doc """
  Returns a list of all possible bitstring renderings of the glyph.

  E.g., normal, with variant selectors, etc. This is useful if you want to have
  all possible values to match against when searching for the glyph in a string
  representation.
  """
  def chars(%EmojiChar{unified: uid, variations: variations}) do
    [uid] ++ variations
    |> Enum.map(&Exmoji.unified_to_char/1)
  end

  @doc """
  Is the EmojiChar represented by a doublebyte codepoint in Unicode?
  """
  def doublebyte?(%EmojiChar{unified: id}) do
    id |> String.match?(~r/-/)
  end

  @doc """
  Does the EmojiChar have an alternate Unicode variant encoding?
  """
  def variant?(%EmojiChar{variations: variations}) do
    length(variations) > 0
  end

  @doc """
  Returns the most likely variant-encoding for an EmojiChar. (For now we only
  know of one possible variant encoding for certain characters, but there could
  be others in the future.)

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
