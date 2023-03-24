defmodule Marko.Monitoring.SessionTrackingWorker do
  @moduledoc """
  Creates session asynchronously
  """

  require Logger

  use GenServer

  alias Marko.Monitoring

  def track_user_activity(tracking_params) do
    GenServer.cast(
      __MODULE__,
      {:track_user_activity, tracking_params}
    )
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_), do: {:ok, %{}}

  def handle_cast({:track_user_activity, tracking_params}, state) do
    case Monitoring.create_activity(tracking_params) do
      {:ok, _} ->
        :ok

      {:error, error_changeset} ->
        Logger.error(fn ->
          "#{__MODULE__} error activity creation for session #{inspect(tracking_params)}. Reason: #{inspect(error_changeset)}"
        end)
    end

    {:noreply, state}
  end
end
