defmodule Marko.Repo.Migrations.CreateSession do
  use Ecto.Migration

  def change do
    create table(:sessions) do
      add(:public_hash_id, :string)

      timestamps()
    end

    create(unique_index(:sessions, [:public_hash_id]))
  end
end
