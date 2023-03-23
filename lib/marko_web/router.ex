defmodule MarkoWeb.Router do
  use MarkoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {MarkoWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :activity_tracking do
    plug(:fetch_cookies, signed: ~w(user_session))
    plug(MarkoWeb.Plugs.PutSession)
    plug(MarkoWeb.Plugs.PutTrackingData)
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MarkoWeb do
    pipe_through [:browser]

    get "/", MonitoringController, :home

    resources "/sessions", SessionController
  end

  scope "/", MarkoWeb do
    pipe_through [:browser, :activity_tracking]

    live_session :activity_tracking,
      layout: {MarkoWeb.Layouts, :pages_layout},
      on_mount: MarkoWeb.LiveSessionCallbacks.TrackPagesVisited do
      live "/page_a", PageA
      live "/page_b", PageB
      live "/page_c", PageC
      live "/page_c/:tab", PageC
    end
  end

  if Application.compile_env(:marko, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: MarkoWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
