defmodule Marko.Components.Navigation do
  use Phoenix.Component

  def list(assigns) do
    ~H"""
    <div class="navigation_list">
      <%= Enum.map(@navigation_configuration, fn {text, path} -> %>
        <div class="navigation_list_item">
          <.link navigate={path}><%= text %></.link>
        </div>
      <% end) %>
    </div>
    """
  end

  def tabs(assigns) do
    ~H"""
    <div class="navigation_tabs">
      <div class="tabs_switch">
        <%= Enum.map(@tabs_list, fn %{active: active, text: text, path: path} -> %>
          <div class={"tab #{if(active, do: "active")}"}>
            <.link navigate={path}><%= text %></.link>
          </div>
        <% end) %>
      </div>
      <div class="tabs_content">
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end
end
