defmodule MarkoWeb.MonitoringController do
  use MarkoWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
