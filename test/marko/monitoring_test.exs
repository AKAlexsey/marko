defmodule Marko.MonitoringTest do
  use Marko.DataCase

  alias Marko.Monitoring

  describe "sessions" do
    alias Marko.Monitoring.Session

    import Marko.MonitoringFixtures

    @invalid_attrs %{public_hash_id: nil}

    test "list_sessions/0 returns all sessions" do
      sessions = sessions_fixture()
      assert Monitoring.list_sessions() == [sessions]
    end

    test "get_sessions!/1 returns the sessions with given id" do
      sessions = sessions_fixture()
      assert Monitoring.get_sessions!(sessions.id) == sessions
    end

    test "create_sessions/1 with valid data creates a sessions" do
      valid_attrs = %{public_hash_id: "some public_hash_id"}

      assert {:ok, %Session{} = sessions} = Monitoring.create_sessions(valid_attrs)
      assert sessions.public_hash_id == "some public_hash_id"
    end

    test "create_sessions/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Monitoring.create_sessions(@invalid_attrs)
    end

    test "update_sessions/2 with valid data updates the sessions" do
      sessions = sessions_fixture()
      update_attrs = %{public_hash_id: "some updated public_hash_id"}

      assert {:ok, %Session{} = sessions} = Monitoring.update_sessions(sessions, update_attrs)
      assert sessions.public_hash_id == "some updated public_hash_id"
    end

    test "update_sessions/2 with invalid data returns error changeset" do
      sessions = sessions_fixture()
      assert {:error, %Ecto.Changeset{}} = Monitoring.update_sessions(sessions, @invalid_attrs)
      assert sessions == Monitoring.get_sessions!(sessions.id)
    end

    test "delete_sessions/1 deletes the sessions" do
      sessions = sessions_fixture()
      assert {:ok, %Session{}} = Monitoring.delete_sessions(sessions)
      assert_raise Ecto.NoResultsError, fn -> Monitoring.get_sessions!(sessions.id) end
    end

    test "change_sessions/1 returns a sessions changeset" do
      sessions = sessions_fixture()
      assert %Ecto.Changeset{} = Monitoring.change_sessions(sessions)
    end
  end
end
