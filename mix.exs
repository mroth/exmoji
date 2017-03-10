defmodule Exmoji.Mixfile do
  use Mix.Project

  def project do
    [
      app:           :exmoji,
      version:       "0.2.2",
      elixir:        "~> 1.1",
      deps:          deps(),
      test_coverage: [tool: ExCoveralls],
      name:          "Exmoji",
      source_url:    "https://github.com/mroth/exmoji",
      description:   description(),
      package:       package(),
      aliases:       aliases()
    ]
  end

  defp description do
    """
    Emoji encoding swiss army knife for dealing with Unicode and other gotchas.
    """
  end

  defp package do
    [
      maintainers:  [ "Matthew Rothenberg <mroth@mroth.info>" ],
      licenses:     [ "MIT" ],
      links:        %{
                       "Docs"   => "https://hexdocs.pm/exmoji/",
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

  # Dependencies
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:poison,       "~> 2.0"},
      {:excoveralls,  "~> 0.4",                 only: :dev},
      {:benchfella,   "~> 0.3",                 only: :dev},
      {:earmark,      "~> 0.2",                 only: :dev},
      {:ex_doc,       "~> 0.11",                only: :dev}
    ]
  end

  defp aliases do
    [
      clean:          ["clean", &clean_docs/1, &clean_benchmarks/1],
      "clean.docs":   [&clean_docs/1],
      "clean.bench":  [&clean_benchmarks/1]
    ]
  end

  defp clean_benchmarks(_), do: File.rm_rf!("bench/snapshots")
  defp clean_docs(_), do: File.rm_rf!("doc")

end
