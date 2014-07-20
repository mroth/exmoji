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
  def variant?(char) do
    length(char.variations) > 0
  end

end
