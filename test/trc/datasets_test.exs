defmodule TRC.DatasetsTest do
  use TRC.DataCase

  alias TRC.Datasets

  describe "twitch" do
    alias TRC.Datasets.Twitch

    import TRC.DatasetsFixtures

    @invalid_attrs %{channel: nil, language: nil, mature: nil, metadata: nil, partnered: nil}

    test "list_twitch/0 returns all twitch" do
      twitch = twitch_fixture()
      assert Datasets.list_twitch() == [twitch]
    end

    test "get_twitch!/1 returns the twitch with given id" do
      twitch = twitch_fixture()
      assert Datasets.get_twitch!(twitch.id) == twitch
    end

    test "create_twitch/1 with valid data creates a twitch" do
      valid_attrs = %{
        channel: "some channel",
        language: "some language",
        mature: true,
        metadata: %{},
        partnered: true
      }

      assert {:ok, %Twitch{} = twitch} = Datasets.create_twitch(valid_attrs)
      assert twitch.channel == "some channel"
      assert twitch.language == "some language"
      assert twitch.mature == true
      assert twitch.metadata == %{}
      assert twitch.partnered == true
    end

    test "create_twitch/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Datasets.create_twitch(@invalid_attrs)
    end

    test "update_twitch/2 with valid data updates the twitch" do
      twitch = twitch_fixture()

      update_attrs = %{
        channel: "some updated channel",
        language: "some updated language",
        mature: false,
        metadata: %{},
        partnered: false
      }

      assert {:ok, %Twitch{} = twitch} = Datasets.update_twitch(twitch, update_attrs)
      assert twitch.channel == "some updated channel"
      assert twitch.language == "some updated language"
      assert twitch.mature == false
      assert twitch.metadata == %{}
      assert twitch.partnered == false
    end

    test "update_twitch/2 with invalid data returns error changeset" do
      twitch = twitch_fixture()
      assert {:error, %Ecto.Changeset{}} = Datasets.update_twitch(twitch, @invalid_attrs)
      assert twitch == Datasets.get_twitch!(twitch.id)
    end

    test "delete_twitch/1 deletes the twitch" do
      twitch = twitch_fixture()
      assert {:ok, %Twitch{}} = Datasets.delete_twitch(twitch)
      assert_raise Ecto.NoResultsError, fn -> Datasets.get_twitch!(twitch.id) end
    end

    test "change_twitch/1 returns a twitch changeset" do
      twitch = twitch_fixture()
      assert %Ecto.Changeset{} = Datasets.change_twitch(twitch)
    end
  end
end
