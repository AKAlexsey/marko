defmodule Marko.Monitoring.Activity do
  use Ecto.Schema
  import Ecto.Changeset

  alias Marko.Monitoring.Session

  @attrs ~w(path metadata session_id seconds_spent view)a
  @required_attrs ~w(path session_id seconds_spent view)a

  schema "activities" do
    belongs_to(:session, Session)
    field :path, :string
    field :view, :string
    field :seconds_spent, :integer, default: 0
    field :metadata, :map, default: %{}

    timestamps()
  end

  @doc false
  def changeset(activity, attrs) do
    activity
    |> cast(attrs, @attrs)
    |> validate_required(@required_attrs)
  end
end
