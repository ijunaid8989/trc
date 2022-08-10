defmodule TRC.QueryHelper.Paginate do
  def paginate(query, repo, params, options \\ []) do
    pagination_config = %{
      page: params["page"] || 1,
      page_size: params["page_size"] || 50,
      options: options
    }

    page = repo.paginate(query, pagination_config)

    %{
      items: eliminate_nils(page.entries),
      total: page.total_entries,
      page: page.page_number,
      page_size: page.page_size,
      from: from(page),
      to: to(page)
    }
  end

  defp from(page) do
    (page.page_number - 1) * page.page_size + 1
  end

  defp to(page) do
    last_item = from(page) + page.page_size - 1
    if last_item > page.total_entries, do: page.total_entries, else: last_item
  end

  defp eliminate_nils(entries) do
    Enum.map(entries, fn entry ->
      for {k, v} <- Map.from_struct(entry) |> Map.delete(:__meta__),
          v != nil,
          into: %{},
          do: {k, v}
    end)
  end
end
