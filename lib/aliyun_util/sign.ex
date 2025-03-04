defmodule Aliyun.Util.Sign do
  @moduledoc """
  签名相关。
  """

  def algorithm, do: "ACS3-HMAC-SHA256"

  @doc """
  签名字符串。

  ## Examples

      iex> key = "YourAccessKeySecret"
      iex> str_to_sign = "ACS3-HMAC-SHA256
      ...>7ea06492da5221eba5297e897ce16e55f964061054b7695beedaac1145b1e259"
      iex> Aliyun.Util.Sign.sign(str_to_sign, key)
      "06563a9e1b43f5dfe96b81484da74bceab24a1d853912eee15083a6f0f3283c0"

  """
  @spec sign(String.t(), String.t()) :: String.t()
  def sign(string_to_sign, key) do
    :crypto.mac(:hmac, :sha256, key, string_to_sign)
    |> Base.encode16(case: :lower)
  end

  @doc """
  生成nounces。

  ## Examples

      iex> <<_::binary-size(16)>> = Aliyun.Util.Sign.gen_nounce()

  """
  @spec gen_nounce(non_neg_integer()) :: String.t()
  def gen_nounce(length \\ 16) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64() |> binary_part(0, length)
  end
end
