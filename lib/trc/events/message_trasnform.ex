defmodule TRC.Events.MessageTrasnform do
  alias Broadway.Message
  alias TRC.Repo

  alias TRC.Datasets.Twitch
  alias TRC.Datasets.MemeGen
  alias TRC.Datasets.CollisionElectron

  def transform(messages) do
    messages
    |> Enum.each(fn %Message{data: data} = message ->
      do_changeset(data.payload, data.event)
      |> Repo.insert()
      |> IO.inspect()
      |> case do
        {:ok, _message} -> :ok
        _error -> Message.failed(message, "missing-column-fields")
      end
    end)
  end

  defp do_changeset(message, "twitch") do
    Twitch.changeset(%Twitch{}, message)
  end

  defp do_changeset(message, "collisionelectron") do
    CollisionElectron.changeset(%CollisionElectron{}, message)
  end

  defp do_changeset(message, "memegen") do
    MemeGen.changeset(%MemeGen{}, message)
  end
end
