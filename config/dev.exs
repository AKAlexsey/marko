import Config

config :logger, level: :info

config :marko, Marko.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "marko_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :marko, MarkoWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "h+LEdu47KEzw3OkZFObFNSST/qmIccNP6HV9lcc+3hJfZIAMEqGtNbcROPOnPry6",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:default, ~w(--watch)]}
  ]

config :marko, MarkoWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/marko_web/(controllers|live|components)/.*(ex|heex)$"
    ]
  ]

config :marko, dev_routes: true

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime

config :swoosh, :api_client, false
