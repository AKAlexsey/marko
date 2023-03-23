defmodule MarkoWeb.SessionHTML do
  use MarkoWeb, :html

  embed_templates "session_html/*"

  @doc """
  Renders a sessions form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def session_form(assigns)
end
