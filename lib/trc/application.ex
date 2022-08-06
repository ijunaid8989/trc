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
      # Start the Ecto repository
      TRC.Repo,
      # Start the Telemetry supervisor
      TRCWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: TRC.PubSub},
      # Start the Endpoint (http/https)
      TRCWeb.Endpoint,
      {publisher, Keyword.put_new(publisher_opts, :name, publisher)},
      {TRC.Events, [publisher: publisher]}
      # Start a worker by calling: TRC.Worker.start_link(arg)
      # {TRC.Worker, arg}
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
