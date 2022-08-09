defmodule TRCWeb.DatasetsController do
  use TRCWeb, :controller

  alias TRC.Datasets.DatasetsDashboard

  action_fallback TRCWeb.FallbackController

  def index(conn, params) do
    datasets = DatasetsDashboard.all(params)

    json(conn, %{datasets: datasets})
  end
end
