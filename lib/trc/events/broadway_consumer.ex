defmodule TRC.Events.BroadwayConsumer do
  use Broadway

  alias Broadway.Message
  alias TRC.Events.MessageTrasnform
  alias Utils

  def start_link(queue) do
    [exchange: exchange, connection: connection] =
      Application.get_env(:trc, TRC.Events.RmqPublisher)

    Broadway.start_link(__MODULE__,
      name: Module.concat([__MODULE__, queue]),
      producer: [
        module:
          {BroadwayRabbitMQ.Producer,
           queue: queue, bindings: [{exchange, []}], connection: connection, on_failure: :reject},
        concurrency: 1
      ],
      processors: [
        default: [
          concurrency: 50
        ]
      ],
      batchers: [
        twitch: [concurrency: 2, batch_size: 20],
        memegen: [concurrency: 2, batch_size: 20],
        collisionelectron: [concurrency: 2, batch_size: 20]
      ]
    )
  end

  @impl true
  def handle_message(_, %Message{data: data} = message, _) do
    batcher = process_data(data).event |> batcher()

    message
    |> Message.update_data(&process_data/1)
    |> Message.put_batcher(batcher)
  end

  @impl true
  def handle_batch(:twitch, messages, _batch_info, _context) do
    MessageTrasnform.transform(messages)

    messages
  end

  def handle_batch(:memegen, messages, _batch_info, _context) do
    MessageTrasnform.transform(messages)

    messages
  end

  def handle_batch(:collisionelectron, messages, _batch_info, _context) do
    MessageTrasnform.transform(messages)

    messages
  end

  defp process_data(data) do
    Jason.decode!(data)
    |> Utils.atomize_map_keys()
  end

  defp batcher("twitch"), do: :twitch
  defp batcher("memegen"), do: :memegen
  defp batcher("collisionelectron"), do: :collisionelectron
end
