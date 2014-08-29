defmodule Exmoji.Mixfile do
  use Mix.Project

  def project do
    [app: :exmoji,
     version: "0.0.1",
     elixir: "~> 0.15.1",
     deps: deps,
     test_coverage: [tool: ExCoveralls]]
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
      {:excoveralls, "~> 0.3", only: :dev}
    ]
  end
end
