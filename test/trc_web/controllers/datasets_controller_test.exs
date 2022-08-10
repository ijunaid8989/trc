defmodule TRCWeb.DatasetsControllerTest do
  use TRCWeb.ConnCase

  import TRC.DatasetsFixtures

  alias TRC.Cache

  setup %{conn: conn} do
    _ = Cache.flush()

    [conn: put_req_header(conn, "accept", "application/json")]
  end

  describe "DatasetsController" do
    setup [:twitch_fixture]
    setup [:meme_gen_fixture]
    setup [:collision_electron_fixture]

    test "index returns the dataset", %{conn: conn} do
      _ = Cache.delete_all()

      response_body =
        get(conn, Routes.datasets_path(conn, :index, %{}))
        |> json_response(200)

      %{"items" => items, "total" => total} = response_body["datasets"]

      assert length(items) == total
    end

    test "index return dataset with valid search topic", %{conn: conn} do
      _ = Cache.delete_all()

      response_body =
        get(conn, Routes.datasets_path(conn, :index, %{"topic" => "collisionelectron"}))
        |> json_response(200)

      %{"items" => [item], "total" => 1} = response_body["datasets"]

      assert "collisionelectron" == item["topic_name"]
    end

    test "index return dataset with valid sort field", %{conn: conn} do
      _ = Cache.delete_all()

      response_body =
        get(conn, Routes.datasets_path(conn, :index, %{"sort" => "topic_name|asc"}))
        |> json_response(200)

      %{"items" => [item1, item2, item3], "total" => 3} = response_body["datasets"]

      assert "collisionelectron" == item1["topic_name"]
      assert "memegen" == item2["topic_name"]
      assert "twitch" == item3["topic_name"]
    end

    test "index return error with for wrong sort field", %{conn: conn} do
      _ = Cache.delete_all()

      response_body =
        get(conn, Routes.datasets_path(conn, :index, %{"sort" => "topic|asc"}))
        |> json_response(422)

      error = response_body["errors"]

      assert error == %{"sort" => ["sort 'field' is invalid."]}
    end

    test "index return error with for wrong sort direction", %{conn: conn} do
      _ = Cache.delete_all()

      response_body =
        get(conn, Routes.datasets_path(conn, :index, %{"sort" => "topic_name|down"}))
        |> json_response(422)

      error = response_body["errors"]

      assert error == %{"sort" => ["sort 'direction' is invalid."]}
    end

    test "index return error with for wrong topic name for filter", %{conn: conn} do
      _ = Cache.delete_all()

      response_body =
        get(conn, Routes.datasets_path(conn, :index, %{"topic" => "harrypoter"}))
        |> json_response(422)

      error = response_body["errors"]

      assert error == %{"topic" => ["is invalid"]}
    end
  end
end
