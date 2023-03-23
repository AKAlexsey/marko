defmodule Marko.Monitoring.SessionTrackingWorker do
  @moduledoc """
  Creates session asynchronously
  """

  require Logger

  use GenServer

  alias Marko.Monitoring

  def track_user_activity(session_id, path, seconds_spent, metadata \\ %{}) do
    GenServer.cast(
      __MODULE__,
      {:track_user_activity, {session_id, path, seconds_spent, metadata}}
    )
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_), do: {:ok, %{}}

  def handle_cast({:track_user_activity, {session_id, path, seconds_spent, metadata}}, state) do
    case Monitoring.create_activity(%{
           session_id: session_id,
           seconds_spent: seconds_spent,
           metadata: metadata,
           path: path
         }) do
      {:ok, _} ->
        :ok

      {:error, error_changeset} ->
        Logger.error(fn ->
          "#{__MODULE__} error activity creation for session #{session_id}. Reason: #{inspect(error_changeset)}"
        end)
    end

    {:noreply, state}
  end
end
