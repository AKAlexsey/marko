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

  describe "activities" do
    alias Marko.Monitoring.Activity

    import Marko.MonitoringFixtures

    @invalid_attrs %{metadata: nil, path: nil, seconds_spent: nil}

    test "list_activities/0 returns all activities" do
      activity = activity_fixture()
      assert Monitoring.list_activities() == [activity]
    end

    test "get_activity!/1 returns the activity with given id" do
      activity = activity_fixture()
      assert Monitoring.get_activity!(activity.id) == activity
    end

    test "create_activity/1 with valid data creates a activity" do
      session = sessions_fixture()
      valid_attrs = %{metadata: %{}, path: "some path", seconds_spent: 1, session_id: session.id}

      assert {:ok, %Activity{} = activity} = Monitoring.create_activity(valid_attrs)
      assert activity.metadata == %{}
      assert activity.path == "some path"
    end

    test "create_activity/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Monitoring.create_activity(@invalid_attrs)
    end

    test "update_activity/2 with valid data updates the activity" do
      activity = activity_fixture()
      update_attrs = %{metadata: %{}, path: "some updated path", seconds_spent: 1}

      assert {:ok, %Activity{} = activity} = Monitoring.update_activity(activity, update_attrs)
      assert activity.metadata == %{}
      assert activity.path == "some updated path"
    end

    test "update_activity/2 with invalid data returns error changeset" do
      activity = activity_fixture()
      assert {:error, %Ecto.Changeset{}} = Monitoring.update_activity(activity, @invalid_attrs)
      assert activity == Monitoring.get_activity!(activity.id)
    end

    test "delete_activity/1 deletes the activity" do
      activity = activity_fixture()
      assert {:ok, %Activity{}} = Monitoring.delete_activity(activity)
      assert_raise Ecto.NoResultsError, fn -> Monitoring.get_activity!(activity.id) end
    end

    test "change_activity/1 returns a activity changeset" do
      activity = activity_fixture()
      assert %Ecto.Changeset{} = Monitoring.change_activity(activity)
    end
  end
end
