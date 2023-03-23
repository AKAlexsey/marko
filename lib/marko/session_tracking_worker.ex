defmodule Marko.Monitoring.SessionTrackingWorker do
  @moduledoc """
  Creates session asynchronously
  """

  use GenServer

  alias Marko.Monitoring

  def track_user_activity(session_id, view, seconds_spent, metadata \\ %{}) do
    GenServer.cast({:track_user_activity, {session_id, view, seconds_spent, metadata}}, __MODULE__)
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_), do: {:ok, %{}}

  def handle_cast({:track_user_activity, {session_id, view, seconds_spent, metadata}}, state) do
    IO.puts("!!! {:create_activity, #{inspect({session_id, view, seconds_spent, metadata})}}")
    # Monitoring.create_activity(%{session_id: session_id, seconds_spent: seconds_spent, metadata: metadata, view: view})

    {:noreply, state}
  end
end
