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


  # for char <- @emoji_chars do
  #   def find_by_n(unquote(char.name)), do: char
  # end
  def find_by_name(name) do
    @emoji_chars |> Enum.filter fn x -> String.contains? x.name, String.upcase(name) end
  end

  @doc """
  Finds an EmojiChar based on the unified codepoint ID.
  """
  def find_by_unified(uid) do
    uid |> String.upcase |> _find_by_unified
  end

  for ec <- @emoji_chars do
    defp _find_by_unified( unquote(ec.unified) ), do: unquote(Macro.escape(ec))
    for variant <- ec.variations do
      defp _find_by_unified( unquote(variant) ), do: unquote(Macro.escape(ec))
    end
  end


end
