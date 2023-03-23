defmodule Marko.Monitoring.Session do
  use Ecto.Schema
  import Ecto.Changeset

  @attrs ~w(public_hash_id)a
  @required_attrs ~w(public_hash_id)a

  schema "sessions" do
    field :public_hash_id, :string

    timestamps()
  end

  @doc false
  def changeset(sessions, attrs) do
    sessions
    |> cast(attrs, @attrs)
    |> validate_required(@required_attrs)
  end
end
