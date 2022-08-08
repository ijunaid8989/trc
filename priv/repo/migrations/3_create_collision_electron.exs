defmodule TRC.Repo.Migrations.CreateCollisionElectron do
  use Ecto.Migration

  def change do
    create table(:collision_electron) do
      add :oid, :uuid, unique: true, null: false
      add :event, :bigint
      add :run, :bigint
      add :energy, :map
      add :momemtum, :map
      add :transverse_momemtum, :map
      add :pseudorapidity, :map
      add :phi_angle, :map
      add :charge, :map
      add :invariant_mass, :decimal

      timestamps()
    end

    create unique_index(:collision_electron, [:oid, :event])
    create index(:collision_electron, [:event, :run])
  end
end
