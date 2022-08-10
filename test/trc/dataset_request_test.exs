defmodule TRC.Dataset.RequestTest do
  use TRC.DataCase

  alias TRC.Dataset.Request

  describe "RequestTest" do
    test "new: returns a valid changeset when map is empty" do
      assert {:ok, _valid} = Request.new(%{})
    end

    test "new: returns a valid changeset when map has only sort param" do
      assert {:ok, _valid} = Request.new(%{"sort" => "inserted_at|asc"})
    end

    test "new: returns a valid changeset when map has only filter param topic" do
      assert {:ok, _valid} = Request.new(%{"topic" => "twitch"})
    end

    test "new: returns a valid changeset when map has filter topic and sort as well" do
      assert {:ok, _valid} = Request.new(%{"topic" => "twitch", "sort" => "inserted_at|asc"})
    end

    test "new: returns invalid when wrong topic is chosen for filter" do
      assert {:error, request} = Request.new(%{"topic" => "twitching"})

      assert errors_on(request) == %{topic: ["is invalid"]}
    end

    test "new: returns invalid when wrong pattern chosen for sort" do
      assert {:error, request} = Request.new(%{"sort" => "asc|inserted_at"})

      assert errors_on(request) == %{sort: ["sort 'direction' is invalid."]}
    end

    test "new: returns invalid when wrong sort field is chosen, not allowed for sort" do
      assert {:error, request} = Request.new(%{"sort" => "id|asc"})

      assert errors_on(request) == %{sort: ["sort 'field' is invalid."]}
    end

    test "new: returns invalid when wrong sort direction is chosen, not allowed for sort" do
      assert {:error, request} = Request.new(%{"sort" => "topic_name|down"})

      assert errors_on(request) == %{sort: ["sort 'direction' is invalid."]}
    end
  end
end
