defmodule Utils do
  @moduledoc """
  General purpose utility functions.
  """

  ## API

  @doc """
  Converts the keys of the given `map` to atoms. It is recursive.

  Raises `ArgumentError` if a key is different than string or atom.

  ## Example

      iex> Nidavellir.Utils.atomize_map_keys(%{"foo" => "bar"})
      %{foo: "bar"}

  """
  @spec atomize_map_keys(map) :: map | no_return
  def atomize_map_keys(map) do
    Enum.into(map, %{}, &atomize_map_key/1)
  end

  ## Private functions

  defp atomize_map_key({key, value}) when is_binary(key) do
    value = atomize_nested_map(value)
    {String.to_atom(key), value}
  end

  defp atomize_map_key({key, value}) when is_atom(key) do
    value = atomize_nested_map(value)
    {key, value}
  end

  defp atomize_map_key({key, _value}) do
    raise ArgumentError, "only strings and atoms supported as a key, got: #{inspect(key)}"
  end

  defp atomize_nested_map(%{__struct__: _} = value) do
    value
  end

  defp atomize_nested_map(value) when is_map(value) do
    atomize_map_keys(value)
  end

  defp atomize_nested_map(value) do
    value
  end
end
