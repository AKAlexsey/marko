defmodule MarkoWeb.PageC do
  @moduledoc false

  use Phoenix.LiveView

  @allowed_tabs ~w(tab_1 tab_2)

  def handle_params(params, _uri, socket) do
    case fetch_tab(params) do
      {:ok, tab} -> socket
      {:redirect, tab} -> redirect(socket, to: "/page_c/#{tab}")
    end
    |> (fn socket -> {:noreply, socket} end).()
  end

  def mount(params, _session, socket) do
    {_, tab} = fetch_tab(params)
    socket = assign(socket, :tab, tab)
    {:ok, socket}
  end

  defp fetch_tab(params) do
    with %{"tab" => tab} <- params,
         true <- tab in @allowed_tabs do
      {:ok, tab}
    else
      _ -> {:redirect, Enum.random(@allowed_tabs)}
    end
  end
end
