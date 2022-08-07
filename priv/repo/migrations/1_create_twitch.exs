defmodule TRC.Repo.Migrations.CreateTwitch do
  use Ecto.Migration

  def change do
    create table(:twitch) do
      add :oid, :uuid, unique: true, null: false
      add :channel, :string
      add :metadata, :map
      add :partnered, :boolean, default: false, null: false
      add :mature, :boolean, default: false, null: false
      add :language, :string

      timestamps()
    end

    create unique_index(:twitch, [:channel, :oid])

    create index(:twitch, [:channel])
  end
end
