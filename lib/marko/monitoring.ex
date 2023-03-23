defmodule Marko.Monitoring do
  @moduledoc """
  The Monitoring context.
  """

  import Ecto.Query, warn: false
  alias Marko.Repo

  alias Marko.Monitoring.{Session, SessionTrackingWorker}

  defdelegate track_user_activity_activity(session_id, view, metadata), to: SessionTrackingWorker

  @doc """
  Returns the list of sessions.

  ## Examples

      iex> list_sessions()
      [%Session{}, ...]

  """
  def list_sessions do
    Repo.all(Session)
  end

  @doc """
  Gets a single sessions.

  Raises `Ecto.NoResultsError` if the Session does not exist.

  ## Examples

      iex> get_sessions!(123)
      %Session{}

      iex> get_sessions!(456)
      ** (Ecto.NoResultsError)

  """
  def get_sessions!(id), do: Repo.get!(Session, id)

  @doc """
  Creates a sessions.

  ## Examples

      iex> create_sessions(%{field: value})
      {:ok, %Session{}}

      iex> create_sessions(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_sessions(attrs \\ %{}) do
    %Session{}
    |> Session.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates new session record with unique public_hash_id
  """
  def create_session_for_tracking() do
    create_sessions(%{public_hash_id: Ecto.UUID.generate()})
  end

  @doc """
  Fetches session by public hash id. Returns nil if haven't found.
  """
  def find_session_by_public_hash_id(public_hash_id) do
    Repo.get_by(Session, %{public_hash_id: public_hash_id})
  end

  @doc """
  Updates a sessions.

  ## Examples

      iex> update_sessions(sessions, %{field: new_value})
      {:ok, %Session{}}

      iex> update_sessions(sessions, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_sessions(%Session{} = sessions, attrs) do
    sessions
    |> Session.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a sessions.

  ## Examples

      iex> delete_sessions(sessions)
      {:ok, %Session{}}

      iex> delete_sessions(sessions)
      {:error, %Ecto.Changeset{}}

  """
  def delete_sessions(%Session{} = sessions) do
    Repo.delete(sessions)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking sessions changes.

  ## Examples

      iex> change_sessions(sessions)
      %Ecto.Changeset{data: %Session{}}

  """
  def change_sessions(%Session{} = sessions, attrs \\ %{}) do
    Session.changeset(sessions, attrs)
  end

  alias Marko.Monitoring.Activity

  @doc """
  Returns the list of activities.

  ## Examples

      iex> list_activities()
      [%Activity{}, ...]

  """
  def list_activities(preload \\ []) do
    Activity
    |> Repo.all()
    |> Repo.preload(preload)
  end

  @doc """
  Gets a single activity.

  Raises `Ecto.NoResultsError` if the Activity does not exist.

  ## Examples

      iex> get_activity!(123)
      %Activity{}

      iex> get_activity!(456)
      ** (Ecto.NoResultsError)

  """
  def get_activity!(id), do: Repo.get!(Activity, id)

  @doc """
  Creates a activity.

  ## Examples

      iex> create_activity(%{field: value})
      {:ok, %Activity{}}

      iex> create_activity(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_activity(attrs \\ %{}) do
    %Activity{}
    |> Activity.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a activity.

  ## Examples

      iex> update_activity(activity, %{field: new_value})
      {:ok, %Activity{}}

      iex> update_activity(activity, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_activity(%Activity{} = activity, attrs) do
    activity
    |> Activity.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a activity.

  ## Examples

      iex> delete_activity(activity)
      {:ok, %Activity{}}

      iex> delete_activity(activity)
      {:error, %Ecto.Changeset{}}

  """
  def delete_activity(%Activity{} = activity) do
    Repo.delete(activity)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking activity changes.

  ## Examples

      iex> change_activity(activity)
      %Ecto.Changeset{data: %Activity{}}

  """
  def change_activity(%Activity{} = activity, attrs \\ %{}) do
    Activity.changeset(activity, attrs)
  end
end
