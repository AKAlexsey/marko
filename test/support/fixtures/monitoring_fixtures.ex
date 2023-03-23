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
        public_hash_id: "some public_hash_id"
      })
      |> Marko.Monitoring.create_sessions()

    sessions
  end
end
