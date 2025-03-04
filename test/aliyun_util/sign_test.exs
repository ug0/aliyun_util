defmodule Aliyun.Util.SignTest do
  use ExUnit.Case
  doctest Aliyun.Util.Sign

  alias Aliyun.Util.Sign

  describe "sign/2" do
    test "sign string" do
      string_to_sign = "ACS3-HMAC-SHA256\n7ea06492da5221eba5297e897ce16e55f964061054b7695beedaac1145b1e259"

      key = "YourAccessKeySecret"
      signature = "06563a9e1b43f5dfe96b81484da74bceab24a1d853912eee15083a6f0f3283c0"

      assert Sign.sign(string_to_sign, key) == signature
    end
  end
end
