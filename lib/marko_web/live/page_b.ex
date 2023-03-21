defmodule MarkoWeb.PageB do
  @moduledoc false

  use Phoenix.LiveView

  alias Marko.Components.Navigation

  @navigation_configuration [
    {"Page A", "/page_a"},
    {"Page C tab 2", "/page_c/tab_2"}
  ]

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :navigation_configuration, @navigation_configuration)}
  end
end
