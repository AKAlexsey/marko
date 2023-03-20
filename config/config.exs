import Config

config :marko,
  ecto_repos: [Marko.Repo]

config :marko, MarkoWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: MarkoWeb.ErrorHTML, json: MarkoWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Marko.PubSub,
  live_view: [signing_salt: "CzrniiSb"]

config :marko, Marko.Mailer, adapter: Swoosh.Adapters.Local

config :esbuild,
  version: "0.14.41",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :tailwind,
  version: "3.2.4",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{config_env()}.exs"
