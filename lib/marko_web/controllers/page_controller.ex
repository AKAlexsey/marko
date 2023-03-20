defmodule MarkoWeb.PageController do
  use MarkoWeb, :controller

  def home(conn, _params) do
    render(conn, :home, layout: false)
  end
end
