defmodule Marko.Monitoring.Session do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sessions" do
    field :public_hash_id, :string

    timestamps()
  end

  @doc false
  def changeset(sessions, attrs) do
    sessions
    |> cast(attrs, [:public_hash_id])
    |> validate_required([:public_hash_id])
  end
end
