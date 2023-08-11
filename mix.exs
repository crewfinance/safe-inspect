defmodule SafeInspect.MixProject do
  use Mix.Project

  def project do
    [
      app: :safe_inspect,
      version: "1.0.1",
      elixir: "~> 1.15",
      deps: deps(),
      description: description(),
      package: package(),
      name: "safe_inspect",
      source_url: "https://github.com/crewfinance/safe-inspect",
      homepage_url: "https://trycrew.com",
      docs: [
        main: "readme",
        extras: ["README.md"]
      ]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.27", only: :dev, runtime: false}
    ]
  end

  defp description() do
    "Safely inspect in your logs by redacting sensitive data"
  end

  defp package() do
    [
      files: ~w(lib .formatter.exs mix.exs README* LICENSE*),
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/crewfinance/safe-inspect"}
    ]
  end
end
