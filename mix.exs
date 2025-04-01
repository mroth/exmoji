defmodule Exmoji.Mixfile do
  use Mix.Project

  @source_url "https://github.com/mroth/exmoji"
  @version "0.3.0"

  def project do
    [
      app: :exmoji,
      version: @version,
      elixir: "~> 1.4",
      test_coverage: [tool: ExCoveralls],
      name: "Exmoji",
      deps: deps(),
      docs: docs(),
      package: package(),
      aliases: aliases()
    ]
  end

  defp package do
    [
      description:
        "Emoji encoding swiss army knife for dealing with Unicode " <>
          "and other gotchas.",
      maintainers: ["Matthew Rothenberg <mroth@mroth.info>", "Fabian Becker <halfdan@xnorfz.de>"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => @source_url
      }
    ]
  end

  def application do
    [extra_applications: []]
  end

  defp deps do
    [
      {:jason, "~> 1.2"},
      {:excoveralls, "~> 0.6", only: :dev},
      {:benchfella, "~> 0.3", only: :dev},
      {:earmark, "~> 1.1", only: :dev},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp docs do
    [
      extras: [
        "LICENSE.md": [title: "License"],
        "README.md": [title: "Overview"]
      ],
      main: "readme",
      source_url: @source_url,
      source_ref: "v#{@version}",
      formatters: ["html"]
    ]
  end

  defp aliases do
    [
      clean: ["clean", &clean_docs/1, &clean_benchmarks/1],
      "clean.docs": [&clean_docs/1],
      "clean.bench": [&clean_benchmarks/1]
    ]
  end

  defp clean_benchmarks(_), do: File.rm_rf!("bench/snapshots")
  defp clean_docs(_), do: File.rm_rf!("doc")
end
