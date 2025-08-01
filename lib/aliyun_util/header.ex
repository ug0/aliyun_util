defmodule Aliyun.Util.Header do
  @moduledoc """
  生成阿里云 API 请求头的工具模块。
  """

  @doc """
  生成阿里云 API 请求头必要参数。

  ## Examples

      iex> Aliyun.Util.header.build_action_headers("SendSms", "2017-05-25")
     %{
        "x-acs-action" => "SendSms",
        "x-acs-date" => "2025-01-01T09:55:28Z",
        "x-acs-signature-nonce" => "74b01bca836ddc6787a82f748b1361f8",
        "x-acs-version" => "2017-05-25"
      }

  """
  @spec build_action_headers(String.t(), String.t()) :: map()
  def build_action_headers(action, version) do
    %{
      "x-acs-action" => action,
      "x-acs-version" => version
    }
    |> Map.put_new("x-acs-date", Aliyun.Util.Time.gmt_now_iso8601())
    |> Map.put_new("x-acs-signature-nonce", gen_nonce())
  end

  defp gen_nonce do
    :crypto.strong_rand_bytes(16) |> Base.encode16() |> String.downcase()
  end
end
