defmodule Aliyun.Util.Request do
  @moduledoc """
  阿里云 V3 版本请求体。
  """
  alias Aliyun.Util.{Config, Encoder, Sign}

  def build!(%Config{} = config, method, url, query_params, headers, body \\ nil) do
    Req.new(method: method, url: url, params: query_params, headers: headers, body: body)
    |> set_hashed_request_payload_header()
    |> set_authorization_header(config)
  end

  def request(%Req.Request{} = req) do
    Req.request(req)
  end

  @hashed_request_header "x-acs-content-sha256"
  defp set_hashed_request_payload_header(%Req.Request{} = req) do
    Req.Request.put_header(req, @hashed_request_header, hash_request_payload(req))
  end

  defp hash_request_payload(%Req.Request{} = req) do
    hash_digest(req.body)
  end

  defp hashed_request_payload(%Req.Request{} = req) do
    [hash] = Req.Request.get_header(req, @hashed_request_header)
    hash
  end

  defp hash_digest(nil) do
    hash_digest("")
  end

  defp hash_digest(data) do
    :crypto.hash(:sha256, data) |> Base.encode16(case: :lower)
  end

  defp set_authorization_header(%Req.Request{} = req, %Config{} = config) do
    signature = calc_signature(req, config)
    authorization = "#{Sign.algorithm} Credential=#{config.access_key_id},SignedHeaders=#{signed_headers(req)},Signature=#{signature}"

    Req.Request.put_header(req, "Authorization", authorization)
  end

  defp calc_signature(%Req.Request{} = req, %Config{} = config) do
    req
    |> string_to_sign()
    |> Sign.sign(config.access_key_secret)
  end

  defp string_to_sign(%Req.Request{} = req) do
    Sign.algorithm <> "\n" <> hash_canonical_request(req)
  end

  defp hash_canonical_request(%Req.Request{} = req) do
    req
    |> canonical_request()
    |> hash_digest()
  end

  defp canonical_request(%Req.Request{} = req) do
    method_string(req) <> "\n" <>
    canonical_uri(req) <>  "\n" <>
    canonical_query_string(req) <> "\n" <>
    canonical_headers(req) <> "\n" <>
    signed_headers(req) <> "\n" <>
    hashed_request_payload(req)
  end

  defp method_string(%Req.Request{} = req), do: req.method |> to_string() |> String.upcase()

  defp canonical_uri(%Req.Request{url: url}), do: url.path |> Encoder.encode_uri()

  defp canonical_query_string(%Req.Request{} = req) do
    req
    |> Req.Request.fetch_option!(:params)
    |> Encoder.encode_params()
  end

  defp canonical_headers(%Req.Request{} = req) do
    req
    |> sort_and_filter_headers(fn
      {"x-acs-" <> _, _} -> true
      {"host", _} -> true
      {"content-type", _} -> true
      _ -> false
    end)
    |> Stream.map(fn {k, v} -> "#{k}:#{String.trim(v)}\n" end)
    |> Enum.join()
  end

  defp signed_headers(%Req.Request{} = req) do
    req
    |> sort_and_filter_headers(fn {k, _} -> k != "authorization" end)
    |> Stream.map(fn {k, _} -> k end)
    |> Enum.join(";")
  end

  defp sort_and_filter_headers(%Req.Request{} = req, filter_fun) do
    req.headers
    |> Stream.map(fn {k, [v]} -> {String.downcase(k), v} end)
    |> Stream.filter(filter_fun)
    |> Enum.sort_by(fn {k, _} -> k end)
  end
end
