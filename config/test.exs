import Config

config :marko, Marko.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "marko_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

config :marko, MarkoWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "77etIEKRnAgqVMmHmhU+SzLG5sTOR43OTQouffrUJScsSdKaCqEskz1GtWbTYbTY",
  server: false

config :marko, Marko.Mailer, adapter: Swoosh.Adapters.Test

config :swoosh, :api_client, false

config :logger, level: :warning

config :phoenix, :plug_init_mode, :runtime
