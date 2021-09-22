defmodule Aliyun.Util.Time do
  @moduledoc """
  处理时间相关。
  """

  @doc """
  生成时间戳。

  日期格式按照ISO8601标准表示，并需要使用UTC时间。

  格式为：YYYY-MM-DDThh:mm:ssZ; 例如：
  2013-08-15T12:00:00Z（为北京时间2013年8月15日20点0分0秒）。

  ## Examples

      iex> Aliyun.Util.Time.gen_timestamp()
      "2021-09-18T03:00:00Z"

  """
  @spec gen_timestamp() :: String.t()
  def gen_timestamp do
    gmt_now_iso8601()
  end

  @doc """
  生成GMT时间戳。

  ## Examples

      iex> Aliyun.Util.Time.gmt_now()
      "Sat, 18 Sep 2021 03:00:00 GMT"

  """
  def gmt_now do
    Timex.now("GMT")
    |> Timex.format!("%a, %d %b %Y %H:%M:%S GMT", :strftime)
  end

  @doc """
  生成GMT时间戳按照ISO8601标准表示。

  ## Examples

      iex> Aliyun.Util.Time.gmt_now_iso8601()
      "2021-09-18T03:00:00Z"

  """
  def gmt_now_iso8601 do
    Timex.now("GMT")
    |> Timex.format!("%FT%TZ", :strftime)
  end
end
