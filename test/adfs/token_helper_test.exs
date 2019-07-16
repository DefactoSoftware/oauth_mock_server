defmodule OauthMockServer.Adfs.TokenHelperTest do
  use ExUnit.Case, async: true

  alias OauthMockServer.Adfs.TokenHelper

  test "encodes map data into a token" do
    token = TokenHelper.create_access_token(%{foo: "bar"})

    assert %Joken.Token{} = Joken.token(token)
  end

  test "encodes string data into a token" do
    token = TokenHelper.create_access_token("foo")

    assert %Joken.Token{} = Joken.token(token)
  end

  test "raises when data is not a map or string" do
    assert_raise FunctionClauseError, fn ->
      TokenHelper.create_access_token(:data)
    end
  end

  test "decodes a valid token" do
    assert %Joken.Token{claims: %{"foo" => "bar"}} =
             %{foo: "bar"}
             |> TokenHelper.create_access_token()
             |> TokenHelper.decode_access_token()
  end

  test "empty claims in valid token generated without json data" do
    assert %Joken.Token{claims: %{}} =
             "foo"
             |> TokenHelper.create_access_token()
             |> TokenHelper.decode_access_token()
  end

  test "error decoding an invalid token" do
    assert %Joken.Token{claims: %{}, error: "Invalid signature"} =
             TokenHelper.decode_access_token("1234")
  end
end
