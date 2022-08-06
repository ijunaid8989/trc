defmodule TRCWeb.TwitchControllerTest do
  use TRCWeb.ConnCase

  import TRC.DatasetsFixtures

  alias TRC.Datasets.Twitch

  @create_attrs %{
    channel: "some channel",
    language: "some language",
    mature: true,
    metadata: %{},
    partnered: true
  }
  @update_attrs %{
    channel: "some updated channel",
    language: "some updated language",
    mature: false,
    metadata: %{},
    partnered: false
  }
  @invalid_attrs %{channel: nil, language: nil, mature: nil, metadata: nil, partnered: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all twitch", %{conn: conn} do
      conn = get(conn, Routes.twitch_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create twitch" do
    test "renders twitch when data is valid", %{conn: conn} do
      conn = post(conn, Routes.twitch_path(conn, :create), twitch: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.twitch_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "channel" => "some channel",
               "language" => "some language",
               "mature" => true,
               "metadata" => %{},
               "partnered" => true
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.twitch_path(conn, :create), twitch: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update twitch" do
    setup [:create_twitch]

    test "renders twitch when data is valid", %{conn: conn, twitch: %Twitch{id: id} = twitch} do
      conn = put(conn, Routes.twitch_path(conn, :update, twitch), twitch: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.twitch_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "channel" => "some updated channel",
               "language" => "some updated language",
               "mature" => false,
               "metadata" => %{},
               "partnered" => false
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, twitch: twitch} do
      conn = put(conn, Routes.twitch_path(conn, :update, twitch), twitch: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete twitch" do
    setup [:create_twitch]

    test "deletes chosen twitch", %{conn: conn, twitch: twitch} do
      conn = delete(conn, Routes.twitch_path(conn, :delete, twitch))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.twitch_path(conn, :show, twitch))
      end
    end
  end

  defp create_twitch(_) do
    twitch = twitch_fixture()
    %{twitch: twitch}
  end
end
