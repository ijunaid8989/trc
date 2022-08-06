defmodule TRC.Events do
  @moduledoc """
  Integration events and/or notifications.

  **NOTE:** This is a wapper for RMQ publisher to avoid blocking calls
  when publishing messages.
  """

  use GenServer

  alias GenRMQ.Publisher
  alias TRC.Events.MessageEncoder
  alias TRC.Events.RmqPublisher

  ## API

  @spec start_link(keyword) :: GenServer.on_start()
  def start_link(opts \\ []) do
    opts =
      opts
      |> Keyword.put_new(:name, __MODULE__)
      |> Keyword.put_new(:publisher, Module.concat([__MODULE__, RmqPublisher]))

    GenServer.start_link(__MODULE__, opts, name: Keyword.fetch!(opts, :name))
  end

  @spec publish(atom | pid, binary, term) :: :ok
  def publish(server \\ __MODULE__, event, payload) do
    GenServer.cast(server, {:publish, event, payload})
  end

  ## GenServer Callbacks

  @impl true
  def init(opts) do
    {:ok, :maps.from_list(opts)}
  end

  @impl true
  def handle_cast(message, state)

  def handle_cast({:publish, _event, _payload}, %{publisher: nil} = state) do
    {:noreply, state}
  end

  def handle_cast({:publish, event, payload}, %{publisher: publisher} = state) do
    routing_key = routing_key(event)

    :telemetry.span([:int, :events, :publish], %{routing_key: routing_key}, fn ->
      case do_publish(publisher, event, payload, routing_key) do
        :ok ->
          {:ok, %{routing_key: routing_key, result: :ok, reason: :ok}}

        {:error, reason} ->
          {:ok, %{routing_key: routing_key, result: :error, reason: reason}}
      end
    end)

    {:noreply, state}
  end

  ## Private Functions

  defp do_publish(publisher, event, payload, routing_key) do
    message = MessageEncoder.encode!(event, payload)

    Publisher.publish(publisher, message, routing_key)
  catch
    :exit, {:timeout, {GenServer, :call, _}} -> {:error, :timeout}
  end

  defp routing_key(event), do: event <> ".events.data"
end
