defmodule Marko.Monitoring.SessionTrackingWorker do
  @moduledoc """
  Creates session asynchronously
  """

  use GenServer

  alias Marko.Monitoring

  def track_user_activity_activity(session_id, view, metadata \\ %{}) do
    GenServer.cast({:track_user_activity_activity, {session_id, view, metadata}}, __MODULE__)
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_), do: {:ok, %{}}

  def handle_cast({:track_user_activity_activity, {session_id, view, metadata}}, state) do
    IO.puts("!!! {:create_activity, #{inspect({session_id, view, metadata})}}")
    # Monitoring.create_activity(%{session_id: session_id, view: view, metadata: metadata})

    {:noreply, state}
  end
end
