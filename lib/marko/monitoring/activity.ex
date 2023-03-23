defmodule Marko.Monitoring.Activity do
  use Ecto.Schema
  import Ecto.Changeset

  alias Marko.Monitoring.Session

  @attrs ~w(view metadata session_id seconds_spent)a
  @required_attrs ~w(view session_id seconds_spent)a

  schema "activities" do
    belongs_to(:session, Session)
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