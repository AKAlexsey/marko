defmodule MarkoWeb.SessionHTML do
  use MarkoWeb, :html

  embed_templates "session_html/*"

  defdelegate display_datetime(datetime), to: MarkoWeb.ActivityHTML
end
