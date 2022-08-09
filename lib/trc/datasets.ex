defmodule TRC.Datasets do
  @moduledoc """
  The Datasets context.
  """

  import Ecto.Query, warn: false
  alias TRC.Repo

  alias TRC.Datasets.Twitch

  alias TRC.Datasets.MemeGen

  alias TRC.Datasets.CollisionElectron

  def create_collision_electron(attrs) do
    CollisionElectron.changeset(%CollisionElectron{}, attrs)
    |> Repo.insert()
  end

  def create_meme_gen(attrs) do
    MemeGen.changeset(%MemeGen{}, attrs)
    |> Repo.insert()
  end

  def create_twitch(attrs) do
    Twitch.changeset(%Twitch{}, attrs)
    |> Repo.insert()
  end
end
