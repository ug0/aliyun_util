defmodule Aliyun.Util.Sign do
  @moduledoc """
  签名相关。
  """
  import Aliyun.Util.Encoder, only: [encode_request: 2]

  @doc """
  签名字符串。

  ## Examples

      iex> key = "da39a3ee5e6b4b0d3255bfef95601890afd80709"
      iex> Aliyun.Util.Sign.sign("ug0", key)
      "lT5/H+dMe7PnMcBTpfvTWzGWOKg="

  """
  @spec sign(String.t(), String.t()) :: String.t()
  def sign(string_to_sign, key) do
    crypto_hmac(:sha, key, string_to_sign)
    |> Base.encode64()
  end

  @doc """
  签名 request。

  ## Examples

      iex> key = "da39a3ee5e6b4b0d3255bfef95601890afd80709"
      iex> Aliyun.Util.Sign.sign("get", %{foo: "bar"}, key)
      "E+z0VjVGET2NYVZjPrAz7Mep8Go="

  """
  @spec sign(String.t(), map(), String.t()) :: String.t()
  def sign(verb, params = %{}, key) do
    sign(encode_request(verb, params), key)
  end

  @doc """
  生成nounces。

  ## Examples

      iex> Aliyun.Util.Sign.gen_nounce()
      "Uv9IRJZ300XBeNPr"

  """
  @spec gen_nounce(non_neg_integer()) :: String.t()
  def gen_nounce(length \\ 16) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64() |> binary_part(0, length)
  end

  # TODO remove when we require OTP 22.1+
  # https://erlang.org/doc/apps/crypto/new_api.html
  if Code.ensure_loaded?(:crypto) and function_exported?(:crypto, :mac, 4) do
    defp hmac_fun(digest, key), do: &:crypto.mac(:hmac, digest, key, &1)
  else
    defp hmac_fun(digest, key), do: &:crypto.hmac(digest, key, &1)
  end

  defp crypto_hmac(method, key, body) do
    hmac_fun(method, key).(body)
  end
end
