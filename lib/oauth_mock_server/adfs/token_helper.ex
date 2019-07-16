defmodule OauthMockServer.Adfs.TokenHelper do
  @moduledoc """
  Helper for generating, signing and decrypting ADFS tokens for testing purposes
  """

  alias Joken
  alias JOSE.JWK

  @cert """
  -----BEGIN CERTIFICATE-----
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
  -----END CERTIFICATE-----

  """

  @key """
  -----BEGIN PRIVATE KEY-----
  MIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDQyKWHOA9zN3uV
  JwXWQJNrDHbIRWYK2nB4ZeV57aAP9LTwG0a+xHeDo9tiqV8U286ro/i8y0Xd7BjH
  C0YMPhtLF61p8KmQfU3XYEfJ2SbddGUuN0rLiMNunGMfHZ276oFnVGb/Y0yRPIPw
  S39fo5Suk1QnSkkXEIVHO7ZqMZcGPUYIYTDpeQxwfKQjkKH+l5tP99FxZzakEKMl
  9QY9PFIdRBEysbuGaafNAHypoCgsmcy6x+KOc1fFAD1f6Zs1tJd92iMAeciq2lFb
  EzNYXKgpI1FJgM52UluMkGwlsWd3regMWgYRdjd2Y5sAOyQzOH29eKyLR8amfxtE
  cqlF0SPNAgMBAAECggEBAKNEFHU+OI6/12tWnbDixKUUlRqdcmOQWB0+iYmkceOo
  V4nfup3ZYyBVFWz8x7a3ANGmIw/34YXeZ63XOgq+0ncRZ/GNWfv8kM+YoerNXiAV
  Mj5GzL2HEFTCBJ1DeqKFinX0Qar6ythUO1TApTVz5QPzf/5NkARyTdbbchVu/AvK
  mxBPqeVUSSewKSBCbiIu1WyIj9UBf1I4AZz4ZORR1g+tucMSMXsN9kHFT+/3USTD
  ARol+ENvwYqOQQLtIcQsNXF28TDoI8/hLyjC62UhiGDW05DxjTTcwDNf6Z6mBkaS
  LonSoGLIfitBNlyvwmeYJTtAChPyipSxsSRzD03yb50CgYEA6JYRkWN1VJC4dUm+
  08fQgQh8s8Yov784PMHz5S5q0TQBTrZSrd+l5qUrYRt0C4Qi2m2Har3vPr3w8VlX
  ZI/IU478MqNehuzNnS5VsXfMCTmJl72iXRnqKiaC/WIQXzqCPmJHTyALLXJC8+rO
  y6Q0/NvPMx+WueXfIVM1k7MJH6MCgYEA5c0roa0tF1ubMrrkMOLwKlJwxNsoEHGC
  UXSu9BZczae4NclXxcTb0J9D6wU6I1JAXAKEmxLgnUT7RK/RhkAcSAVS0uM9z2WP
  MFD0iKzqKue2RoM6AmpCSz5HrAXSjNgUfADGOMbYL1Yv5mYKW/f3Kobz1Nz8LiY4
  p/HyaXaKJc8CgYEAwnpRAD+oqOhFxJTAQncuieYd13hXNFXg4TTQCg8w8/LHMRjU
  s1xxbRUo247IDqUTO48gDwn4FX9fC3/HymdLe0rw6CqgbLNvDgHjV3wzGHeK7F19
  eNmlak8/cj1gMTBMHXux4qCJmBuVjj0FY1PPlqr5aub78j8avtPD1dd7Rn8CgYAT
  IKvEDlUVf6OAanv58bnJ3AjU6eUA0WHmg87YNFBPMemsWHD83jDpwYf2tP2s2PjQ
  b8k32y9lB8veYMAQ658vA3psYUvQyoRLokFoavQm1Big7+VRNCUGfE2c7PMklAvI
  cowNR8fQ0Ny10cKE+zPQj2EWU7qN4NKQcBwcWSiQkwKBgQCVAAQjHJuk1mW5V06a
  4XXN0R7FS+QlWg7pijg4xcAfFPW8EzoQD0QWXocc9gfr+ziikcN7GzXzTHDuc5/q
  xNYRykYM2Kc4RuFqBnVIMXMjnGfWADrCKAJCCnLwQnWTvfy8fYvfmu5Ph2ajyLr1
  2FyKpUP2+Kq/kOHnJlyVrCMePg==
  -----END PRIVATE KEY-----
  """

  def create_access_token(claims) do
    with [pem_key_data] <- :public_key.pem_decode(@key),
         %Joken.Signer{} = signer <-
           pem_key_data |> :public_key.pem_entry_decode() |> JWK.from_key() |> Joken.rs256() do
      claims
      |> Joken.token()
      |> Joken.with_signer(signer)
      |> Joken.sign()
      |> Joken.get_compact()
    end
  end

  def decode_access_token(token) do
    with %Joken.Signer{} = signer <- @cert |> JWK.from_pem() |> Joken.rs256() do
      token
      |> Joken.token()
      |> Joken.with_signer(signer)
      |> Joken.verify()
    end
  end
end
