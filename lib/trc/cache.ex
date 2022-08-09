adapter =
  :trc
  |> Application.get_env(TRC.Cache, [])
  |> Keyword.get(:adapter, Nebulex.Adapters.Local)

defmodule TRC.Cache do
  @moduledoc false
  use Nebulex.Cache,
    otp_app: :trc,
    adapter: adapter

  @doc false
  def dispatch_cache_info do
    :telemetry.execute(
      [:cache, :info],
      %{size: count_all()},
      %{cache: __MODULE__}
    )
  end
end

defmodule TRC.Cache.Local do
  @moduledoc false
  use Nebulex.Cache,
    otp_app: :trc,
    adapter: Nebulex.Adapters.Local

  @doc false
  def dispatch_cache_info do
    :telemetry.execute(
      [:cache, :local, :info],
      %{size: count_all()},
      %{cache: __MODULE__}
    )
  end
end
