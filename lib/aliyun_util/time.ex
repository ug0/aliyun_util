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
    Timex.now("GMT")
    |> Timex.format!("%Y-%m-%dT%H:%M:%SZ", :strftime)
  end
end
