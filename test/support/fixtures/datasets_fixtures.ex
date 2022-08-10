defmodule TRC.DatasetsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TRC.Datasets` context.
  """

  @doc """
  Generate a twitch.
  """
  def twitch_fixture(attrs \\ %{}) do
    {:ok, twitch} =
      attrs
      |> Enum.into(%{
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
      })
      |> TRC.Datasets.create_twitch()

    [twitch: twitch]
  end

  @doc """
  Generate a meme_gen.
  """
  def meme_gen_fixture(attrs \\ %{}) do
    {:ok, meme_gen} =
      attrs
      |> Enum.into(%{
        alternate_text: "some alternate_text",
        archived_url: "some archived_url",
        base_meme_name: "some base_meme_name",
        file_size: 42,
        md5_hash: "some md5_hash",
        meme_id: 42,
        meme_page_url: "some meme_page_url"
      })
      |> TRC.Datasets.create_meme_gen()

    meme_gen
  end

  @doc """
  Generate a collision_electron.
  """
  def collision_electron_fixture(attrs \\ %{}) do
    {:ok, collision_electron} =
      attrs
      |> Enum.into(%{
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
        transverse_momentum: %{
          pt1: 2.9,
          pt2: 2.9
        }
      })
      |> TRC.Datasets.create_collision_electron()

    collision_electron
  end
end
