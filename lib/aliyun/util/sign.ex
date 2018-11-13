defmodule Aliyun.Util.Sign do
  @moduledoc """
    签名相关
  """
  import Aliyun.Util.Encoder, only: [encode_request: 2]

  @doc """
    签名字符串
  """
  @spec sign(binary(), binary()) :: binary()
  def sign(string_to_sign, key) do
    :crypto.hmac(:sha, key, string_to_sign)
    |> Base.encode64()
  end

  @doc """
    签名 request
  """
  @spec sign(binary(), map(), binary()) :: binary()
  def sign(verb, params = %{}, key) do
    sign(encode_request(verb, params), key)
  end

  @spec gen_nounce(non_neg_integer()) :: binary()
  def gen_nounce(length \\ 16) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64() |> binary_part(0, length)
  end
end
