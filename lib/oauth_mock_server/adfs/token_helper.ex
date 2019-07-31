defmodule OauthMockServer.Adfs.TokenHelper do
  @moduledoc """
  Helper for generating, signing and decrypting ADFS tokens for testing purposes
  """

  alias Joken
  alias JOSE.JWK

  def create_access_token(claims) do
    with [pem_key_data] <- private_key() |> :public_key.pem_decode(),
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
    with %Joken.Signer{} = signer <- public_key() |> JWK.from_pem() |> Joken.rs256() do
      token
      |> Joken.token()
      |> Joken.with_signer(signer)
      |> Joken.verify()
    end
  end

  defp public_key,
    do: "keys/adfs.cer" |> Path.expand(:code.priv_dir(:oauth_mock_server)) |> File.read!()

  defp private_key,
    do: "keys/adfs.key" |> Path.expand(:code.priv_dir(:oauth_mock_server)) |> File.read!()
end
