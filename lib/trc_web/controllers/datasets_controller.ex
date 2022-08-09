defmodule TRCWeb.DatasetsController do
  use TRCWeb, :controller

  alias TRC.Datasets

  action_fallback TRCWeb.FallbackController

  def index(conn, params) do
  end
end
