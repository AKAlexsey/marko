defmodule MarkoWeb.PageA do
  @moduledoc false

  use Phoenix.LiveView

  alias Marko.Components.Navigation

  @navigation_configuration [
    {"Page B", "/page_b"},
    {"Page C tab 1", "/page_c/tab_1"}
  ]

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :navigation_configuration, @navigation_configuration)}
  end
end
