defmodule Exmoji.Mixfile do
  use Mix.Project

  def project do
    [
      app:           :exmoji,
      version:       "0.2.1",
      elixir:        "~> 1.0.0-rc1",
      deps:          deps,
      test_coverage: [tool: ExCoveralls],
      name:          "Exmoji",
      source_url:    "https://github.com/mroth/exmoji",
      description:   description,
      package:       package,
      aliases:       aliases
    ]
  end

  defp description do
    """
    Emoji encoding swiss army knife for dealing with Unicode and other gotchas.
    """
  end

  defp package do
    [
      contributors: [ "Matthew Rothenberg <mroth@mroth.info>" ],
      licenses:     [ "MIT" ],
      links:        %{
                       "Docs"   => "https://mroth.github.io/exmoji/",
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
      {:poison,       "~> 1.5"},
      {:excoveralls,  "~> 0.3",                   only: :dev},
      {:benchfella,   github: "alco/benchfella",  only: :dev},
      {:earmark,      "~> 0.1",                   only: :dev},
      {:ex_doc,       "~> 0.6.0",                 only: :dev}
    ]
  end

  defp aliases do
    [
      clean:          ["clean", &clean_docs/1, &clean_benchmarks/1],
      "clean.docs":   [&clean_docs/1],
      "clean.bench":  [&clean_benchmarks/1],
      "docs.release": [&release_docs/1]
    ]
  end

  defp clean_benchmarks(_), do: File.rm_rf!("bench/snapshots")
  defp clean_docs(_), do: File.rm_rf!("docs")

  defp release_docs(_) do
    additional_files = ["README.md"]
    Mix.Task.run "clean.docs"
    :os.cmd 'git clone --branch gh-pages `git config --get remote.origin.url` docs'
    Mix.Task.run "docs"
    Enum.each(additional_files, &File.cp!(&1, Path.join("docs", &1)))
    File.cd! "docs", fn ->
      :os.cmd 'git add -A .'
      :os.cmd 'git commit -m "Updated docs"'
      :os.cmd 'git push origin gh-pages'
    end

    Mix.shell.info [:green, "Updated docs pushed to origin/gh-pages."]
  end

end
