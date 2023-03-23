defmodule Marko.Repo.Migrations.CreateActivities do
  use Ecto.Migration

  def change do
    create table(:activities) do
      add :view, :string
      add :metadata, :map
      add :seconds_spent, :integer
      add :session_id, references(:sessions, on_delete: :nothing)

      timestamps()
    end

    create index(:activities, [:session_id])
  end
end
