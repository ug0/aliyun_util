defmodule Aliyun.UtilTest do
  use ExUnit.Case
  doctest Aliyun.Util

  test "README install version check" do
    app = :aliyun_util

    app_version = "#{Application.spec(app, :vsn)}"
    readme = File.read!("README.md")
    [_, readme_versions] = Regex.run(~r/{:#{app}, "(.+)"}/, readme)

    assert Version.match?(
             app_version,
             readme_versions
           ),
           """
           Install version constraint in README.md does not match to current app version.
           Current App Version: #{app_version}
           Readme Install Versions: #{readme_versions}
           """
  end
end
