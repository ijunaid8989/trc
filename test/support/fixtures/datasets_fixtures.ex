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
end
