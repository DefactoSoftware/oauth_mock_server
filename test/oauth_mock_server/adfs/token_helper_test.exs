defmodule OauthMockServer.Adfs.TokenHelperTest do
  use ExUnit.Case, async: true

  alias OauthMockServer.Adfs.TokenHelper

  test "encodes map data into a token" do
    token = TokenHelper.create_access_token(%{foo: "bar"})

    assert %{"iss" => "Joken", "foo" => "bar"} = TokenHelper.decode_access_token(token)
  end

  test "raises when data is not a map" do
    assert_raise FunctionClauseError, fn ->
      TokenHelper.create_access_token(:atom_data)
    end

    assert_raise FunctionClauseError, fn ->
      TokenHelper.create_access_token("string_data")
    end
  end

  test "decodes a valid token" do
    assert %{"iss" => "Joken", "foo" => "bar"} =
             %{foo: "bar"}
             |> TokenHelper.create_access_token()
             |> TokenHelper.decode_access_token()
  end

  test "empty claims in valid token generated without claims" do
    assert %{"iss" => "Joken"} =
             TokenHelper.create_access_token() |> TokenHelper.decode_access_token()
  end

  test "error decoding an invalid token" do
    assert {:error, :signature_error} == TokenHelper.decode_access_token("1234")
  end
end
