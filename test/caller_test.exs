defmodule CallerTest do
  use ExUnit.Case
  doctest Caller

  test "greets the world" do
    assert Caller.hello() == :world
  end

  # test "getches token using code" do
  #   assert Caller.Gitter.get_token("1e288013a3a6eaa5bf69c46c63434aa516002931") == "ok"
  # end

  test "fetches room by name" do
    assert Map.get(Caller.Gitter.get_room_by_name("VentureGroup/ThatTestRoom").body, "id") == "5bd195c3d73408ce4facb1ec"
  end

  # test "sends room message" do
  #   assert Caller.Gitter.room_message("5bd195c3d73408ce4facb1ec", "New test").status_code == 200
  # end

  test "get room messages" do
    assert List.last(Caller.Gitter.get_messages("5bd195c3d73408ce4facb1ec", "caller")) == "/caller make standy great again"
  end

  test "read and reply" do
    message = List.first(Caller.Gitter.get_messages("5bd195c3d73408ce4facb1ec", "caller+say"))

    assert message != nil

    number = Regex.named_captures(~r/say (?<number>\d+)/, message)
    |> Map.get("number")

    message = if number == "30" do
      "Meh."
    else
      "It's " <> number <> " dumbass!"
    end

    Caller.Gitter.room_message("5bd195c3d73408ce4facb1ec", message)
  end
end
