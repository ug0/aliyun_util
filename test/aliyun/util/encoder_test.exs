defmodule Aliyun.Util.EncoderTest do
  use ExUnit.Case
  doctest Aliyun.Util.Encoder

  alias Aliyun.Util.Encoder

  describe "encode_string/1" do
    test "encode string" do
      string_to_encode = "Aa0-_.~\" +*&"
      encoded_string = "Aa0-_.~%22%20%2B%2A%26"

      assert Encoder.encode_string(string_to_encode) == encoded_string
    end
  end
end
