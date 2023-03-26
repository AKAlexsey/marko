defmodule MarkoWeb.Plugs.PutSession do
  @moduledoc """
  It's necessary to track user spend time visit statistics.

  To provide it - it's necessary to set unique cookie for session.
  """

  @session_cookie_name "user_session"

  import Plug.Conn, only: [put_resp_cookie: 4, put_session: 3]

  alias Marko.Monitoring

  @doc false
  @spec session_cookie_name() :: String.t()
  def session_cookie_name(), do: @session_cookie_name

  @doc false
  @spec init(Plug.opts()) :: Plug.opts()
  def init(options), do: options

  @doc """
  Assign admin into conn's assigns.
  Admin based on reference in Guardian token.
  """
  @spec call(Plug.Conn.t(), Plug.opts()) :: Plug.Conn.t()
  def call(conn, _options) do
    %{id: session_id, public_hash_id: public_hash_id} = get_session(conn)

    conn
    |> put_resp_cookie(@session_cookie_name, %{id: public_hash_id}, sign: true)
    |> put_session(:session_id, session_id)
  end

  defp get_session(%{cookies: cookies}) do
    with %{id: public_hash_id} <- Map.get(cookies, @session_cookie_name),
         %{} = session <- Monitoring.find_session_by_public_hash_id(public_hash_id) do
      session
    else
      _ ->
        {:ok, session} = Monitoring.create_session_for_tracking()
        session
    end
  end
end
