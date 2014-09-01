defmodule Exmoji.Util.Unified do
  @moduledoc false

  # actual conversion function, used by `Exmoji.Util` to generate precompiled
  # methods, and also used as a fallback for unmatched values.
  def _unified_to_char(uid) do
    uid
    |> String.split("-")
    |> Enum.map( &(String.to_integer(&1, 16)) )
    |> List.to_string
  end

end

defmodule Exmoji.Util.Char do
  @moduledoc false

  # actual conversion function, used by `Exmoji.Util` to generate precompiled
  # methods, and also used as a fallback for unmatched values.
  def _char_to_unified(char) do
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


defmodule Exmoji.Util do
  @moduledoc """
  Provides utility functions to convert between Unicode unified ID values and
  rendered Emoji glyphs in bitstring format.

  Pattern matched with precompiled values for all known Emoji character values
  for maximum speed, with fallbacks to algorithmic conversion.
  """

  alias Exmoji.EmojiChar
  alias Exmoji.Util.Unified
  alias Exmoji.Util.Char

  @doc """
  Convert a unified ID directly to its bitstring glyph representation.

  Precompiled only for uppercase format of the hex ID.

  ## Example

      iex> Exmoji.Util.unified_to_char("1F47E")
      "👾"

  """
  for ec <- Exmoji.all do
    uid = ec.unified
    def unified_to_char( unquote(uid) ) do
      unquote( Unified._unified_to_char(uid) )
    end
  end

  for ec <- Exmoji.all_with_variants do
    variant_id = EmojiChar.variant(ec)
    def unified_to_char( unquote(variant_id) ) do
      unquote( Unified._unified_to_char(variant_id) )
    end
  end

  def unified_to_char(uid), do: Unified._unified_to_char(uid)


  @doc """
  Convert a native bitstring glyph to its unified codepoint ID.

  ## Examples

      iex> Exmoji.Util.char_to_unified("👾")
      "1F47E"

      iex> Exmoji.Util.char_to_unified("\x{23}\x{fe0f}\x{20e3}")
      "0023-FE0F-20E3"

  """
  # create pattern matches (variants must be first)
  for ec <- Exmoji.all_with_variants do
    variant = List.first(ec.variations)
    def char_to_unified( unquote(Unified._unified_to_char(variant)) ) do
      unquote(variant)
    end
  end

  for ec <- Exmoji.all do
    def char_to_unified( unquote(Unified._unified_to_char(ec.unified)) ) do
      unquote(ec.unified)
    end
  end

  # if not found, fallback
  def char_to_unified(uid), do: Char._char_to_unified(uid)

end
