defmodule MarkoWeb.ActivityHTML do
  use MarkoWeb, :html

  embed_templates "activity_html/*"

  def display_datetime(datetime) do
    datetime
    |> NaiveDateTime.truncate(:second)
    |> NaiveDateTime.to_iso8601()
    |> String.split("T")
    |> Enum.reverse()
    |> Enum.join(" ")
  end
end
