defmodule TRCWeb.DatasetsController do
  use TRCWeb, :controller

  alias TRC.Dataset.Request
  alias TRC.Datasets.DatasetsDashboard

  action_fallback TRCWeb.FallbackController

  def index(conn, params) do
    with {:ok, _valid_request} <- Request.new(params) do
      datasets = DatasetsDashboard.all(params)

      json(conn, %{datasets: datasets})
    end
  end
end
