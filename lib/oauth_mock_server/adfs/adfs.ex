defmodule OauthMockServer.Adfs do
  @moduledoc """
    A server that simulates ADFS responses.
  """

  use OauthMockServer.Conn

  alias OauthMockServer.Adfs.TokenHelper

  def valid_metadata,
    do: """
    <EntityDescriptor>
      <ds:Signature>
        <KeyInfo>
          <X509Data>
            <X509Certificate>
              MIIDCzCCAfOgAwIBAgIQKG24wJq9CaNB4Mqk7ntlNDANBgkqhkiG9w0BAQsFADAX
              MRUwEwYDVQQDEwxkZXRyb2l0LXRlc3QwIBcNMTkwNzEyMDgzMzMwWhgPMjExODA3
              MTIwODQzMzBaMBcxFTATBgNVBAMTDGRldHJvaXQtdGVzdDCCASIwDQYJKoZIhvcN
              AQEBBQADggEPADCCAQoCggEBANDIpYc4D3M3e5UnBdZAk2sMdshFZgracHhl5Xnt
              oA/0tPAbRr7Ed4Oj22KpXxTbzquj+LzLRd3sGMcLRgw+G0sXrWnwqZB9TddgR8nZ
              Jt10ZS43SsuIw26cYx8dnbvqgWdUZv9jTJE8g/BLf1+jlK6TVCdKSRcQhUc7tmox
              lwY9RghhMOl5DHB8pCOQof6Xm0/30XFnNqQQoyX1Bj08Uh1EETKxu4Zpp80AfKmg
              KCyZzLrH4o5zV8UAPV/pmzW0l33aIwB5yKraUVsTM1hcqCkjUUmAznZSW4yQbCWx
              Z3et6AxaBhF2N3ZjmwA7JDM4fb14rItHxqZ/G0RyqUXRI80CAwEAAaNRME8wCwYD
              VR0PBAQDAgGGMA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFNYUnDNTKbq7rhID
              p3WBtFpliJFwMBAGCSsGAQQBgjcVAQQDAgEAMA0GCSqGSIb3DQEBCwUAA4IBAQCA
              s9ku0UQjUqw2wlMgGAZ+4Q3iEZ2Dl+eZVf89dv9zDhwUZH0prOxqK1torZNFiYjD
              yGcetsX/Xxln7HgKqzJjyodUunPyKAW99IvjEDMJKSqUPfcMHclR0ZpFRcXJpuJZ
              rcrf3itK3oduhyYaHP6tqmzOQrVrJe4E70mNOhrXsH6YZVJlb5IxRoOjCsGgMXvr
              R2YQzynnJKEbni4FItX6Qm72q9PfPp+pHHrPWEtpHUt4Xe0sdE5Vq01smpMfcpHD
              sSS9qCst8xi9twg73hcxgcQLnkN7S7qAwmJXxBNfsg905KLEJzkdHwiQLJg8aSju
              4i5Qo2fMqP+RUZTZEnKZ
            </X509Certificate>
          </X509Data>
        </KeyInfo>
      </ds:Signature>
    </EntityDescriptor>
    """

  def metadata(conn), do: send_resp(conn, 200, valid_metadata())

  def authorize(%Conn{params: %{"redirect_uri" => redirect_uri}} = conn) do
    user =
      case conn.params do
        %{"user" => user} -> user
        %{"client_id" => user} -> user
        _ -> "john_doe"
      end

    redirect(conn, "#{redirect_uri}?code=#{user}")
  end

  def authorize(conn), do: send_resp(conn, 200, "")

  def token(%Conn{params: %{"code" => "error"}} = conn), do: send_resp(conn, 503, "")

  def token(%Conn{params: %{"code" => user_name}} = conn),
    do: token_response(conn, user_name)

  defp token_response(conn, subject) do
    access_token = TokenHelper.create_access_token(%{sub: subject})
    send_resp(conn, 200, Jason.encode!(%{access_token: access_token}))
  end
end
