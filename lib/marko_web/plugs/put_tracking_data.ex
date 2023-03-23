defmodule MarkoWeb.Plugs.PutTrackingData do
  @moduledoc """
  It's necessary to track user spend time visit statistics.

  To provide it - it's necessary to set unique cookie for session.
  """

  @user_agent_header "user-agent"

  import Plug.Conn, only: [put_session: 3, get_req_header: 2]

  @doc false
  @spec init(Plug.opts()) :: Plug.opts()
  def init(options), do: options

  @doc """
  Assign admin into conn's assigns.
  Admin based on reference in Guardian token.
  """
  @spec call(Plug.Conn.t(), Plug.opts()) :: Plug.Conn.t()
  def call(conn, _options) do
    fetch_and_assign_user_agent(conn)
  end

  defp fetch_and_assign_user_agent(conn) do
    put_user_agent(conn)
  end

  defp put_user_agent(conn) do
    [user_agent] = get_req_header(conn, @user_agent_header)

    put_session(conn, :user_agent, user_agent)
  end
end
