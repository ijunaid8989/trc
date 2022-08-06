defmodule TRC.Events.MessageEncoder do
  @moduledoc """
  Encapsulates encoding integration event message.
  """

  # alias Janus.Accounts.Account Alias Twitch here

  def encode!(event, payload) do
    Jason.encode!(%{
      event: event,
      payload: %{name: "Junaid"},
      published_at: DateTime.utc_now()
    })
  end
end
