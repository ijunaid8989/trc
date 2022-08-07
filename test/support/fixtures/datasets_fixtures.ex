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
        metadata: %{},
        partnered: true
      })

    # |> TRC.Datasets.create_twitch()

    twitch
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
        charge: %{},
        energy: %{},
        event: 42,
        invariant_mass: "120.5",
        momemtum: %{},
        phi_angle: %{},
        pseudorapidity: %{},
        run: 42,
        transverse_momentum: %{}
      })
      |> TRC.Datasets.create_collision_electron()

    collision_electron
  end
end
