defmodule AliyunUtil.MixProject do
  use Mix.Project

  @source_url "https://github.com/ug0/aliyun_util"
  @version "0.3.4"

  def project do
    [
      app: :aliyun_util,
      version: @version,
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:timex, "~> 3.1"}
    ]
  end

  defp package do
    [
      description: "Aliyun API utils",
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url}
    ]
  end

  defp docs do
    [
      extras: [
        "LICENSE.md": [title: "License"],
        "README.md": [title: "Overview"]
      ],
      main: "readme",
      source_urL: @source_url,
      source_ref: "v#{@version}",
      homapage_url: @source_url,
      formatters: ["html"]
    ]
  end
end
