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

  def render(%EmojiChar{unified: unified}) do
    unified
    |> String.split("-")
    |> Enum.map(&String.to_integer(&1, 16))
    |> to_string
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
