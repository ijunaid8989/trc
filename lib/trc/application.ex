defmodule TRC.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    publisher = TRC.Events.RmqPublisher
    publisher_opts = Application.get_env(:trc, publisher)

    children = [
      TRC.Repo,
      TRC.Cache.Local,
      TRC.Cache,
      TRCWeb.Telemetry,
      {Phoenix.PubSub, name: TRC.PubSub},
      TRCWeb.Endpoint,
      {publisher, Keyword.put_new(publisher_opts, :name, publisher)},
      {TRC.Events, [publisher: publisher]},
      # TRC.Streamer,
      Supervisor.child_spec({TRC.Events.BroadwayConsumer, "twitch"}, id: :twitch),
      Supervisor.child_spec({TRC.Events.BroadwayConsumer, "memegen"}, id: :memegen),
      Supervisor.child_spec({TRC.Events.BroadwayConsumer, "collisionelectron"},
        id: :collisionelectron
      )
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TRC.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TRCWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
