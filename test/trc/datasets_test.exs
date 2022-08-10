defmodule TRC.DatasetsTest do
  use TRC.DataCase

  alias TRC.Datasets

  describe "Twitch" do
    test "it creates a twitch" do
      attrs = %{
        channel: "some channel",
        language: "some language",
        mature: true,
        metadata: %{
          watch_time: 345,
          stream_time: 345,
          peak_viewers: 345,
          average_viewers: 345,
          followers: 345,
          followers_gained: 345,
          views_gained: 345
        },
        partnered: true
      }

      assert {:ok, _twitch} = Datasets.create_twitch(attrs)
    end

    test "invalid for missing fields in base model." do
      attrs = %{
        mature: true,
        metadata: %{
          watch_time: 345,
          stream_time: 345,
          peak_viewers: 345,
          average_viewers: 345,
          followers: 345,
          followers_gained: 345,
          views_gained: 345
        },
        partnered: true
      }

      assert {:error, twitch} = Datasets.create_twitch(attrs)
      assert errors_on(twitch) == %{channel: ["can't be blank"], language: ["can't be blank"]}
    end

    test "missing details on metadata" do
      attrs = %{
        channel: "some channel",
        language: "some language",
        mature: true,
        metadata: %{
          watch_time: 345,
          followers_gained: 345,
          views_gained: 345
        },
        partnered: true
      }

      assert {:error, twitch} = Datasets.create_twitch(attrs)

      assert errors_on(twitch) == %{
               metadata: %{
                 average_viewers: ["can't be blank"],
                 followers: ["can't be blank"],
                 peak_viewers: ["can't be blank"],
                 stream_time: ["can't be blank"]
               }
             }
    end
  end

  describe "Memegen" do
    test "it creates a memegen" do
      attrs = %{
        alternate_text: "some alternate_text",
        archived_url: "some archived_url",
        base_meme_name: "some base_meme_name",
        file_size: 42,
        md5_hash: "some md5_hash",
        meme_id: 42,
        meme_page_url: "some meme_page_url"
      }

      assert {:ok, _memegen} = Datasets.create_meme_gen(attrs)
    end

    test "invalid for missing fields in base model." do
      attrs = %{
        alternate_text: "some alternate_text",
        archived_url: "some archived_url",
        base_meme_name: "some base_meme_name",
        meme_id: 42,
        meme_page_url: "some meme_page_url"
      }

      assert {:error, twitch} = Datasets.create_meme_gen(attrs)

      assert errors_on(twitch) == %{
               file_size: ["can't be blank"],
               md5_hash: ["can't be blank"]
             }
    end
  end

  describe "Collision Electron" do
    test "it creates a collision" do
      attrs = %{
        charge: %{
          q1: 3,
          q2: 3
        },
        energy: %{
          e1: 23,
          e2: 23
        },
        event: 42,
        invariant_mass: "120.5",
        momemtum: %{
          px1: 3.45,
          py1: 3.45,
          pz1: 3.45,
          px2: 3.45,
          py2: 3.45,
          pz2: 3.45
        },
        phi_angle: %{
          phi1: 3.2,
          phi2: 3.2
        },
        pseudorapidity: %{
          eta1: 4.5,
          eta2: 4.5
        },
        run: 42,
        transverse_momemtum: %{
          pt1: 2.9,
          pt2: 2.9
        }
      }

      assert {:ok, _collision} = Datasets.create_collision_electron(attrs)
    end

    test "invalid for missing fields in base model." do
      attrs = %{
        charge: %{
          q1: 3,
          q2: 3
        },
        energy: %{
          e1: 23,
          e2: 23
        },
        momemtum: %{
          px1: 3.45,
          py1: 3.45,
          pz1: 3.45,
          px2: 3.45,
          py2: 3.45,
          pz2: 3.45
        },
        phi_angle: %{
          phi1: 3.2,
          phi2: 3.2
        },
        pseudorapidity: %{
          eta1: 4.5,
          eta2: 4.5
        },
        transverse_momemtum: %{
          pt1: 2.9,
          pt2: 2.9
        }
      }

      assert {:error, collision} = Datasets.create_collision_electron(attrs)

      assert errors_on(collision) == %{
               event: ["can't be blank"],
               invariant_mass: ["can't be blank"],
               run: ["can't be blank"]
             }
    end

    test "invalid for missing fields in embeds_one." do
      attrs = %{
        charge: %{
          q1: 3,
          q2: 3
        },
        energy: %{
          e1: 23,
          e2: 23
        },
        event: 42,
        invariant_mass: "120.5",
        pseudorapidity: %{
          eta1: 4.5,
          eta2: 4.5
        },
        run: 42,
        transverse_momentum: %{
          pt1: 2.9,
          pt2: 2.9
        }
      }

      assert {:error, collision} = Datasets.create_collision_electron(attrs)

      assert errors_on(collision) == %{
               transverse_momemtum: ["can't be blank"],
               momemtum: ["can't be blank"],
               phi_angle: ["can't be blank"]
             }
    end
  end
end
