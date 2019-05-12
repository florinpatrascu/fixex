defmodule Fixex.MixProject do
  use Mix.Project

  @url_github "https://github.com/florinpatrascu/fixex"

  def project do
    [
      app: :fixex,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description:
        "FixEx adds a simple support for integrating ExUnit with external apps/cli, for using them as external fixtures providers",
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:erlport, "~> 0.10", optional: true, runtime: false},

      # Testing, linting dependencies
      {:dialyxir, "1.0.0-rc.6", only: [:dev], runtime: false},
      {:mix_test_watch, "~> 0.9", only: [:dev, :test]},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp package do
    %{
      files: [
        "lib",
        "mix.exs",
        "LICENSE"
      ],
      licenses: ["Apache 2.0"],
      maintainers: ["Florin T.PATRASCU"],
      links: %{
        "Github" => @url_github
      }
    }
  end
end
