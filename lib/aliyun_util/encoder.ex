defmodule Aliyun.Util.Encoder do
  @doc """
  编码字符串：使用UTF-8字符集按照RFC3986的规则

  ## Examples

      iex> Aliyun.Util.Encoder.encode_string("foo bar")
      "foo%20bar"

  """
  @spec encode_string(String.t()) :: String.t()
  def encode_string(term) do
    term
    |> to_string()
    |> URI.encode(&URI.char_unreserved?/1)
  end

  @doc """
  编码URI：对URI中的每一部分（即被/分割开的字符串）进行编码

  ## Examples

      iex> Aliyun.Util.Encoder.encode_uri("/foo bar/test/")
      "/foo%20bar/test/"

  """
  @spec encode_uri(String.t()) :: String.t()
  def encode_uri(term) do
    term
    |> to_string()
    |> String.split("/")
    |> Stream.map(&encode_string/1)
    |> Enum.join("/")
  end

  @doc """
  编码 query params。

  ## Options

  - `:strict_nil` - Defaults to `false`.

  ## Examples

      iex> Aliyun.Util.Encoder.encode_params(%{"ImageId" => "win2019_1809_x64_dtc_zh-cn_40G_alibase_20230811.vhd", "RegionId" => "cn-shanghai"})
      "ImageId=win2019_1809_x64_dtc_zh-cn_40G_alibase_20230811.vhd&RegionId=cn-shanghai"
      iex> Aliyun.Util.Encoder.encode_params(%{"empty_value" => nil})
      "empty_value="
      iex> Aliyun.Util.Encoder.encode_params(%{"empty_value" => nil}, strict_nil: true)
      "empty_value"

  """
  @spec encode_params(map(), keyword()) :: String.t()
  def encode_params(params, options \\ []) do
    encoder =
      case Keyword.get(options, :strict_nil, false) do
        true ->
          fn
            {k, nil} -> encode_string(k)
            {k, v} -> encode_string(k) <> "=" <> encode_string(v)
          end

        _ ->
          fn {k, v} -> encode_string(k) <> "=" <> encode_string(v) end
      end

    params
    |> Enum.sort()
    |> Stream.map(encoder)
    |> Enum.join("&")
  end
end
