defmodule Caller.Gitter do
  use HTTPotion.Base

  def process_url(url) when url == "https://gitter.im/login/oauth/token" do
    url
  end

  def process_url(url) do
    "https://api.gitter.im/v1/" <> url
  end

  def process_request_headers(headers) do
    {:ok, token} = Application.fetch_env(:caller, :token)
    headers
    |> Keyword.put(:"Authorization", "Bearer " <> token)
    |> Keyword.put(:"Accept", "application/json")
    |> Keyword.put(:"Content-Type", "application/json")
  end

  def process_response_body(body) do
    body |> Poison.decode!
  end

  def get_token(code) do
    Map.get(
      post( 
        "https://gitter.im/login/oauth/token",
        [body: Poison.encode!(%{
                client_id: Application.fetch_env!(:caller, :client_id),
                client_secret: Application.fetch_env!(:caller, :secret),
                code: code,
                redirect_uri: Application.fetch_env!(:caller, :redirect_uri),
                grant_type: "authorization_code"
                              })]).body, "access_token")
  end

  def get_room_by_name(name) do
    post("rooms", [body: Poison.encode!(%{uri: name})])
  end

  def room_message(room_id, message) do
    post(
      "rooms/" <> room_id <> "/chatMessages",
      [body: Poison.encode!(%{text: message})]
    )
  end

  def get_messages(room_id, query) do
    get_messages_text(get("rooms/" <> room_id <> "/chatMessages?q=" <> query).body)
  end

  defp get_messages_text([message | body]) do
    [Map.get(message, "text") | get_messages_text(body)]
  end
  defp get_messages_text([]) do
    []
  end
end
