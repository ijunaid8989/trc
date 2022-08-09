# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

# Helper
to_int = fn var, default ->
  if val = System.get_env(var), do: String.to_integer(val), else: default
end

config :trc,
  namespace: TRC,
  ecto_repos: [TRC.Repo]

# Configures the endpoint
config :trc, TRCWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: TRCWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: TRC.PubSub,
  live_view: [signing_salt: "fZNgSmuG"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :trc, TRC.Events.RmqPublisher,
  exchange: "datastream",
  connection: "amqp://guest:guest@localhost:5672"

config :trc, TRC.Cache, telemetry_prefix: [:cache]

# Local Cache
config :trc, TRC.Cache.Local,
  telemetry_prefix: [:cache, :local],
  stats: true,
  gc_interval: to_int.("CACHE_GC_INTERVAL", :timer.hours(12)),
  max_size: to_int.("CACHE_MAX_SIZE", 1_000_000),
  gc_cleanup_min_timeout: to_int.("CACHE_MIN_CLEANUP_INTERVAL", 10_000),
  gc_cleanup_max_timeout: to_int.("CACHE_MAX_CLEANUP_INTERVAL", 600_000)

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
