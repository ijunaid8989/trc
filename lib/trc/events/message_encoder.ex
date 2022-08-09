defmodule TRC.Events.MessageEncoder do
  @moduledoc """
  Encapsulates encoding integration event message.
  """

  def encode!(event, payload) do
    Jason.encode!(%{
      event: event,
      payload: payload,
      published_at: DateTime.utc_now()
    })
  end
end
