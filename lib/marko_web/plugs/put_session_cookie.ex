defmodule MarkoWeb.Plugs.PutSessionCookie do
  @moduledoc """
  It's necessary to track user spend time visit statistics.

  To provide it - it's necessary to set unique cookie for session.
  """

  import Plug.Conn, only: [put_resp_cookie: 4]

  @doc false
  @spec init(Plug.opts()) :: Plug.opts()
  def init(options), do: options

  @doc """
  Assign admin into conn's assigns.
  Admin based on reference in Guardian token.
  """
  @spec call(Plug.Conn.t(), Plug.opts()) :: Plug.Conn.t()
  def call(%{cookies: cookies} = conn, _options) do
    conn
    |> put_resp_cookie("user_session", %{id: 1_100}, sign: true)
  end
end
