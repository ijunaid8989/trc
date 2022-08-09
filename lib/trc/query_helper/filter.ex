defmodule TRC.QueryHelper.Filter do
  @moduledoc """
  Behaviour for builidng Ecto query filters
  """

  @type query :: Ecto.Query.t()
  @type key :: String.t() | atom
  @type value :: term()

  @doc """
  Callback to handle specific values when building the query
  """
  @callback filter(query, key, value) :: query
end
