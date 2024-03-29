import Config

# Helper
to_int = fn var, default ->
  if val = System.get_env(var), do: String.to_integer(val), else: default
end

# Configure your database
config :trc, TRC.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "trc_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with esbuild to bundle .js and .css sources.
config :trc, TRCWeb.Endpoint,
  # Binding to loopback ipv4 address prevents access from other machines.
  # Change to `ip: {0, 0, 0, 0}` to allow access from other machines.
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "zfdLMxWTJLxPuHbBcEGG3ckoYGmaB3qApwYwU4sEImXVjf58a8bf1N5D1xbV5wUz",
  watchers: []

# ## SSL Support
#
# In order to use HTTPS in development, a self-signed
# certificate can be generated by running the following
# Mix task:
#
#     mix phx.gen.cert
#
# Note that this task requires Erlang/OTP 20 or later.
# Run `mix help phx.gen.cert` for more information.
#
# The `http:` config above can be replaced with:
#
#     https: [
#       port: 4001,
#       cipher_suite: :strong,
#       keyfile: "priv/cert/selfsigned_key.pem",
#       certfile: "priv/cert/selfsigned.pem"
#     ],
#
# If desired, both `http:` and `https:` keys can be
# configured to run both http and https servers on
# different ports.

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

# Cache
config :trc, TRC.Cache,
  stats: true,
  gc_interval: to_int.("CACHE_GC_INTERVAL", :timer.hours(12)),
  max_size: to_int.("CACHE_MAX_SIZE", 1_000_000),
  gc_cleanup_min_timeout: to_int.("CACHE_MIN_CLEANUP_INTERVAL", 10_000),
  gc_cleanup_max_timeout: to_int.("CACHE_MAX_CLEANUP_INTERVAL", 600_000)

config :trc, TRC.Cache,
  adapter: NebulexRedisAdapter,
  conn_opts: [
    # Redix options
    host: "127.0.0.1",
    port: 6379
  ],
  socket_opts: [
    verify: :verify_none
  ]
