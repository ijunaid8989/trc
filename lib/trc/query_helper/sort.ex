defmodule TRC.QueryHelper.Sort do
  import Ecto.Query

  @directions ["desc", "asc"]

  def sort(query, params, allowed_fields) do
    case parse_sort_params(params, allowed_fields) do
      {direction, field} ->
        query |> order_by({^nulls_order(direction), ^field})

      _ ->
        query
    end
  end

  defp parse_sort_params(%{"sort" => sort}, allowed_fields) do
    with [field, direction] <- String.split(sort, "|"),
         true <- direction in @directions,
         true <- field in allowed_fields do
      {String.to_atom(direction), String.to_atom(field)}
    end
  end

  defp parse_sort_params(_params, _), do: {}

  defp nulls_order(:desc), do: :desc_nulls_last
  defp nulls_order(:asc), do: :asc_nulls_first
end
