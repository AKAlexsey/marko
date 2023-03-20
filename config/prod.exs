import Config

config :marko, MarkoWeb.Endpoint, cache_static_manifest: "priv/static/cache_manifest.json"

config :swoosh, api_client: Swoosh.ApiClient.Finch, finch_name: Marko.Finch

config :logger, level: :info
