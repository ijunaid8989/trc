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

  describe "memegen" do
    alias TRC.Datasets.MemeGen

    import TRC.DatasetsFixtures

    @invalid_attrs %{
      alternate_text: nil,
      archived_url: nil,
      base_meme_name: nil,
      file_size: nil,
      md5_hash: nil,
      meme_id: nil,
      meme_page_url: nil
    }

    test "list_memegen/0 returns all memegen" do
      meme_gen = meme_gen_fixture()
      assert Datasets.list_memegen() == [meme_gen]
    end

    test "get_meme_gen!/1 returns the meme_gen with given id" do
      meme_gen = meme_gen_fixture()
      assert Datasets.get_meme_gen!(meme_gen.id) == meme_gen
    end

    test "create_meme_gen/1 with valid data creates a meme_gen" do
      valid_attrs = %{
        alternate_text: "some alternate_text",
        archived_url: "some archived_url",
        base_meme_name: "some base_meme_name",
        file_size: 42,
        md5_hash: "some md5_hash",
        meme_id: 42,
        meme_page_url: "some meme_page_url"
      }

      assert {:ok, %MemeGen{} = meme_gen} = Datasets.create_meme_gen(valid_attrs)
      assert meme_gen.alternate_text == "some alternate_text"
      assert meme_gen.archived_url == "some archived_url"
      assert meme_gen.base_meme_name == "some base_meme_name"
      assert meme_gen.file_size == 42
      assert meme_gen.md5_hash == "some md5_hash"
      assert meme_gen.meme_id == 42
      assert meme_gen.meme_page_url == "some meme_page_url"
    end

    test "create_meme_gen/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Datasets.create_meme_gen(@invalid_attrs)
    end

    test "update_meme_gen/2 with valid data updates the meme_gen" do
      meme_gen = meme_gen_fixture()

      update_attrs = %{
        alternate_text: "some updated alternate_text",
        archived_url: "some updated archived_url",
        base_meme_name: "some updated base_meme_name",
        file_size: 43,
        md5_hash: "some updated md5_hash",
        meme_id: 43,
        meme_page_url: "some updated meme_page_url"
      }

      assert {:ok, %MemeGen{} = meme_gen} = Datasets.update_meme_gen(meme_gen, update_attrs)
      assert meme_gen.alternate_text == "some updated alternate_text"
      assert meme_gen.archived_url == "some updated archived_url"
      assert meme_gen.base_meme_name == "some updated base_meme_name"
      assert meme_gen.file_size == 43
      assert meme_gen.md5_hash == "some updated md5_hash"
      assert meme_gen.meme_id == 43
      assert meme_gen.meme_page_url == "some updated meme_page_url"
    end

    test "update_meme_gen/2 with invalid data returns error changeset" do
      meme_gen = meme_gen_fixture()
      assert {:error, %Ecto.Changeset{}} = Datasets.update_meme_gen(meme_gen, @invalid_attrs)
      assert meme_gen == Datasets.get_meme_gen!(meme_gen.id)
    end

    test "delete_meme_gen/1 deletes the meme_gen" do
      meme_gen = meme_gen_fixture()
      assert {:ok, %MemeGen{}} = Datasets.delete_meme_gen(meme_gen)
      assert_raise Ecto.NoResultsError, fn -> Datasets.get_meme_gen!(meme_gen.id) end
    end

    test "change_meme_gen/1 returns a meme_gen changeset" do
      meme_gen = meme_gen_fixture()
      assert %Ecto.Changeset{} = Datasets.change_meme_gen(meme_gen)
    end
  end

  describe "collision_electron" do
    alias TRC.Datasets.CollisionElectron

    import TRC.DatasetsFixtures

    @invalid_attrs %{
      charge: nil,
      energy: nil,
      event: nil,
      invariant_mass: nil,
      momemtum: nil,
      phi_angle: nil,
      pseudorapidity: nil,
      run: nil,
      transverse_momentum: nil
    }

    test "list_collision_electron/0 returns all collision_electron" do
      collision_electron = collision_electron_fixture()
      assert Datasets.list_collision_electron() == [collision_electron]
    end

    test "get_collision_electron!/1 returns the collision_electron with given id" do
      collision_electron = collision_electron_fixture()
      assert Datasets.get_collision_electron!(collision_electron.id) == collision_electron
    end

    test "create_collision_electron/1 with valid data creates a collision_electron" do
      valid_attrs = %{
        charge: %{},
        energy: %{},
        event: 42,
        invariant_mass: "120.5",
        momemtum: %{},
        phi_angle: %{},
        pseudorapidity: %{},
        run: 42,
        transverse_momentum: %{}
      }

      assert {:ok, %CollisionElectron{} = collision_electron} =
               Datasets.create_collision_electron(valid_attrs)

      assert collision_electron.charge == %{}
      assert collision_electron.energy == %{}
      assert collision_electron.event == 42
      assert collision_electron.invariant_mass == Decimal.new("120.5")
      assert collision_electron.momemtum == %{}
      assert collision_electron.phi_angle == %{}
      assert collision_electron.pseudorapidity == %{}
      assert collision_electron.run == 42
      assert collision_electron.transverse_momentum == %{}
    end

    test "create_collision_electron/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Datasets.create_collision_electron(@invalid_attrs)
    end

    test "update_collision_electron/2 with valid data updates the collision_electron" do
      collision_electron = collision_electron_fixture()

      update_attrs = %{
        charge: %{},
        energy: %{},
        event: 43,
        invariant_mass: "456.7",
        momemtum: %{},
        phi_angle: %{},
        pseudorapidity: %{},
        run: 43,
        transverse_momentum: %{}
      }

      assert {:ok, %CollisionElectron{} = collision_electron} =
               Datasets.update_collision_electron(collision_electron, update_attrs)

      assert collision_electron.charge == %{}
      assert collision_electron.energy == %{}
      assert collision_electron.event == 43
      assert collision_electron.invariant_mass == Decimal.new("456.7")
      assert collision_electron.momemtum == %{}
      assert collision_electron.phi_angle == %{}
      assert collision_electron.pseudorapidity == %{}
      assert collision_electron.run == 43
      assert collision_electron.transverse_momentum == %{}
    end

    test "update_collision_electron/2 with invalid data returns error changeset" do
      collision_electron = collision_electron_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Datasets.update_collision_electron(collision_electron, @invalid_attrs)

      assert collision_electron == Datasets.get_collision_electron!(collision_electron.id)
    end

    test "delete_collision_electron/1 deletes the collision_electron" do
      collision_electron = collision_electron_fixture()
      assert {:ok, %CollisionElectron{}} = Datasets.delete_collision_electron(collision_electron)

      assert_raise Ecto.NoResultsError, fn ->
        Datasets.get_collision_electron!(collision_electron.id)
      end
    end

    test "change_collision_electron/1 returns a collision_electron changeset" do
      collision_electron = collision_electron_fixture()
      assert %Ecto.Changeset{} = Datasets.change_collision_electron(collision_electron)
    end
  end
end
