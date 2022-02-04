defmodule OauthMockServer.Adfs.TokenHelper do
  @moduledoc """
  Helper for generating, signing and decrypting ADFS tokens for testing purposes
  """

  import Joken.Config

  def create_access_token(claims \\ nil) do
    with signer <- Joken.Signer.create("RS256", %{"pem" => private_key()}),
         {:ok, token, _} <- Joken.generate_and_sign(default_claims(), claims, signer) do
      token
    end
  end

  def decode_access_token(token) do
    with signer <- Joken.Signer.create("RS256", %{"pem" => public_key()}),
         {:ok, claims} <- Joken.verify_and_validate(default_claims(), token, signer) do
      claims
    end
  end

  defp public_key,
    do: "keys/adfs.cer" |> Path.expand(:code.priv_dir(:oauth_mock_server)) |> File.read!()

  defp private_key,
    do: "keys/adfs.key" |> Path.expand(:code.priv_dir(:oauth_mock_server)) |> File.read!()
end
