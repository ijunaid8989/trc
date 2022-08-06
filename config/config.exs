# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

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


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
