defmodule Aliyun.Util.RequestTest do
  use ExUnit.Case
  doctest Aliyun.Util.Request

  alias Aliyun.Util.{Config, Request}

  describe "Request.build!/6" do
    setup do
      config = Config.new!(%{access_key_id: "YourAccessKeyId", access_key_secret: "YourAccessKeySecret"})
      headers = %{
        "x-acs-signature-nonce" => "3156853299f313e23d1673dc12e1703d",
        "x-acs-date" => "2023-10-26T10:22:32Z",
        "x-acs-action" => "RunInstances",
        "x-acs-version" => "2014-05-26",
        "host" => "ecs.cn-shanghai.aliyuncs.com"
      }
      %{config: config, headers: headers}
    end

    test "build a request", %{config: config, headers: headers} do
      authorization = "ACS3-HMAC-SHA256 Credential=YourAccessKeyId,SignedHeaders=host;x-acs-action;x-acs-content-sha256;x-acs-date;x-acs-signature-nonce;x-acs-version,Signature=06563a9e1b43f5dfe96b81484da74bceab24a1d853912eee15083a6f0f3283c0"
      query_params = %{
        "ImageId" => "win2019_1809_x64_dtc_zh-cn_40G_alibase_20230811.vhd",
        "RegionId" => "cn-shanghai"
      }


      req = Request.build!(config, :post, "https://ecs.cn-shanghai.aliyuncs.com/", query_params, headers)
      assert req.method == :post
      assert %{
        url: %{
          scheme: "https",
          host: "ecs.cn-shanghai.aliyuncs.com",
          path: "/",
          query: nil
        },
        options: %{
          params: %{
            "ImageId" => "win2019_1809_x64_dtc_zh-cn_40G_alibase_20230811.vhd",
            "RegionId" => "cn-shanghai"
          }
        }
      } = req
      assert req.body == nil
      assert %{
        "authorization" => [^authorization],
        "x-acs-signature-nonce" => ["3156853299f313e23d1673dc12e1703d"],
        "x-acs-date" => ["2023-10-26T10:22:32Z"],
        "x-acs-action" => ["RunInstances"],
        "x-acs-version" => ["2014-05-26"],
        "host" => ["ecs.cn-shanghai.aliyuncs.com"]
      } = req.headers
    end
  end
end
