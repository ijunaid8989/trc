defmodule TRCWeb.DatasetsController do
  use TRCWeb, :controller

  alias TRC.Datasets

  action_fallback TRCWeb.FallbackController
end
