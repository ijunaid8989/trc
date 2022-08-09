defmodule TRC.Repo.Migrations.CreateMemegen do
  use Ecto.Migration

  def change do
    create table(:memegen) do
      add :oid, :uuid, unique: true, null: false
      add :meme_id, :bigint
      add :archived_url, :text
      add :base_meme_name, :string
      add :meme_page_url, :text
      add :md5_hash, :string
      add :file_size, :bigint
      add :alternate_text, :text

      timestamps()
    end

    create unique_index(:memegen, [:meme_id, :oid])
    create index(:memegen, [:meme_id])
  end
end
