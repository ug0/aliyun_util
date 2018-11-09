defmodule Aliyun.Util do
  @moduledoc """
  Documentation for Aliyun.Util.
  """

  import Aliyun.Util.Encoder

  @doc """
    签名字符串
  """
  @spec sign( binary(), binary()) :: binary()
  def sign(string_to_sign, key) do
    :crypto.hmac(:sha, key, string_to_sign)
    |> Base.encode64()
  end

  @doc """
    签名 request
  """
  @spec sign( binary(), map(), binary()) :: binary()
  def sign(verb, params = %{}, key) do
    sign(encode_request(verb, params), key)
  end

end
