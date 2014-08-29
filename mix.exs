defmodule Exmoji.Mixfile do
  use Mix.Project

  def project do
    [
      app:           :exmoji,
      version:       "0.0.1",
      elixir:        "~> 0.15.1",
      deps:          deps,
      test_coverage: [tool: ExCoveralls],
      name:          "Exmoji",
      source_url:    "https://github.com/mroth/exmoji",
      description:   description,
      package:       package
    ]
  end

  defp description do
    """
    An Elixir/Erlang library providing low level operations for dealing with
    Emoji glyphs in the Unicode standard.
    """
  end

  defp package do
    [
      contributors: [ "Matthew Rothenberg <mroth@mroth.info>" ],
      licenses:     [ "MIT" ],
      links:        %{
                      #  "Docs"   => "https://mroth.github.io/exmoji/",
                       "GitHub" => "https://github.com/mroth/exmoji"
                    }
    ]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: []]
  end

  # Dependencies can be hex.pm packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:jazz, "~> 0.2.0"},
      {:exprof, "~> 0.1.2", only: :dev},
      {:excoveralls, "~> 0.3", only: :dev}
    ]
  end
end
