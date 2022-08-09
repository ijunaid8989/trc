defmodule TRC.QueryHelper do
  defmacro __using__(_opts) do
    quote do
      import TRC.QueryHelper.Paginate, only: [paginate: 3, paginate: 4]
      import TRC.QueryHelper.Sort, only: [sort: 3]

      @bahaviour TRC.QueryHelper.Filter

      @spec filter(Ecto.Queryable.t(), map()) :: Ecto.Query.t()
      def filter(query, params) do
        params
        |> Enum.reject(&(elem(&1, 1) == ""))
        |> Enum.reduce(query, fn {key, value}, query ->
          filter(query, key, value)
        end)
      end

      def filter(%Ecto.Query{} = query, _key, _value), do: query
      defoverridable filter: 3
    end
  end
end
