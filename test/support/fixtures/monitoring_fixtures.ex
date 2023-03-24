defmodule Marko.MonitoringFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Marko.Monitoring` context.
  """

  @doc """
  Generate a sessions.
  """
  def sessions_fixture(attrs \\ %{}) do
    {:ok, sessions} =
      attrs
      |> Enum.into(%{
        public_hash_id: Ecto.UUID.generate()
      })
      |> Marko.Monitoring.create_sessions()

    sessions
  end

  @doc """
  Generate a activity.
  """
  def activity_fixture(attrs \\ %{}) do
    {:ok, activity} =
      attrs
      |> Enum.into(%{
        metadata: %{},
        path: "some path",
        seconds_spent: 1
      })
      |> Map.put_new(:session_id, Map.get(sessions_fixture(), :id))
      |> Marko.Monitoring.create_activity()

    activity
  end
end
