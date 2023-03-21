defmodule MarkoWeb.PageA do
  @moduledoc false

  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
