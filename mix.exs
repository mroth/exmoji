defmodule Exmoji.Mixfile do
  use Mix.Project

  def project do
    [
      app:           :exmoji,
      version:       "0.2.0-pre",
      elixir:        "~> 0.15.1",
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
    An Elixir/Erlang library providing low level operations for dealing with
    Emoji glyphs in the Unicode standard.
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
      {:jazz, "~> 0.2.0"},
      {:exprof, "~> 0.1.2", only: :dev}, #TODO: maybe remove me if not needed soon
      {:excoveralls, "~> 0.3", only: :dev},
      {:benchfella, github: "alco/benchfella", only: :dev},
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.5.0", only: :dev}
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
