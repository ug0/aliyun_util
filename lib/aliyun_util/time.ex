defmodule Aliyun.Util.Time do
  @moduledoc """
    处理时间相关
  """

  @doc """
    生成时间戳。日期格式按照ISO8601标准表示，并需要使用UTC时间。
    格式为：YYYY-MM-DDThh:mm:ssZ;例如，2013-08-15T12:00:00Z（为北京时间2013年8月15日20点0分0秒）
  """
  @spec gen_timestamp() :: String.t()
  def gen_timestamp do
    gmt_now_iso8601()
  end

  @doc """
  e.g.
    "Tue, 27 Nov 2018 04:58:42 GMT"
  """
  def gmt_now do
    Timex.now("GMT")
    |> Timex.format!("%a, %d %b %Y %H:%M:%S GMT", :strftime)
  end

  def gmt_now_iso8601 do
    Timex.now("GMT")
    |> Timex.format!("%FT%TZ", :strftime)
  end
end
