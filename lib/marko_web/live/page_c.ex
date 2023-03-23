defmodule MarkoWeb.PageC do
  @moduledoc false

  use Phoenix.LiveView

  alias Marko.Components.Navigation
  alias MarkoWeb.LiveSessionCallbacks.TrackPagesVisited

  @tab_1 "tab_1"
  @tab_2 "tab_2"
  @allowed_tabs [@tab_1, @tab_2]

  @navigation_configuration %{
    @tab_1 => [
      {"Page A", "/page_a"}
    ],
    @tab_2 => [
      {"Page B", "/page_b"}
    ]
  }

  def handle_params(params, uri, socket) do
    case fetch_tab(params) do
      {:ok, _tab} -> socket
      {:redirect, tab} -> redirect(socket, to: "/page_c/#{tab}")
    end
    |> TrackPagesVisited.assign_page_path(uri)
    |> (fn socket -> {:noreply, socket} end).()
  end

  def mount(params, _session, socket) do
    {_, tab} = fetch_tab(params)

    navigation_configuration = Map.get(@navigation_configuration, tab)

    socket =
      socket
      |> assign(:navigation_configuration, navigation_configuration)
      |> assign(:tabs_list, make_tabs_list(tab))
      |> assign(:tab, tab)

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

  defp make_tabs_list(selected_tab) do
    Enum.map(@allowed_tabs, fn tab ->
      %{
        active: tab == selected_tab,
        path: tab_path(tab),
        text: tab_text(tab)
      }
    end)
  end

  defp tab_path(tab), do: "/page_c/#{tab}"

  defp tab_text(tab) do
    tab
    |> String.capitalize()
    |> String.replace("_", " ")
  end

  def terminate(_reason, socket) do
    TrackPagesVisited.on_terminate(socket)
  end
end
