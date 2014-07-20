defmodule Exmoji do

  alias Exmoji.EmojiChar

  #
  # Read and parse the Emoji library from our vendored data file.
  #
  rawfile = File.read!("vendor/emoji-data/emoji.json")
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


  # for char <- @emoji_chars do
  #   def find_by_n(unquote(char.name)), do: char
  # end
  def find_by_name(name) do
    @emoji_chars |> Enum.filter fn x -> String.contains? x.name, String.upcase(name) end
  end

end
