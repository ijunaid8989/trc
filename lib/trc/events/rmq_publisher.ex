defmodule TRC.Events.RmqPublisher do
  @moduledoc """
  RMQ publisher for notifying account events.
  """

  @behaviour GenRMQ.Publisher

  require Logger

  ## Process lifecycle

  @spec child_spec(keyword) :: Supervisor.child_spec()
  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {GenRMQ.Publisher, :start_link, [__MODULE__, opts]}
    }
  end

  ## GenRMQ.Publisher Callbacks

  @impl true
  def init do
    [exchange: exchange, connection: connection] = Application.get_env(:trc, __MODULE__)

    create_and_bind_topic(connection, exchange)

    [
      exchange: {:topic, exchange},
      connection: connection
    ]
  end

  defp create_and_bind_topic(connection, exchange) do
    {:ok, connection} = AMQP.Connection.open(connection)
    {:ok, channel} = AMQP.Channel.open(connection)

    AMQP.Exchange.declare(channel, exchange, :topic, durable: true)

    Enum.each(["twitch", "memegen", "collisionelectron"], fn source ->
      AMQP.Queue.declare(channel, source, durable: true)

      AMQP.Queue.bind(channel, source, exchange, routing_key: source <> ".events.data")

      Logger.debug(fn -> "#{source} has been declared for queue and bound to exchange" end)
    end)

    AMQP.Channel.close(channel)
    AMQP.Connection.close(connection)
    #RMQ Publisher will have its own connection and channel
  end
end
