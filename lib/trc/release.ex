defmodule TRC.Release do
  @moduledoc false

  alias Ecto.Migrator

  @app :trc

  @doc false
  def migrate do
    _ = load_app()

    for repo <- repos() do
      {:ok, _, _} = Migrator.with_repo(repo, &Migrator.run(&1, :up, all: true))
    end
  end

  @doc false
  def rollback(repo, version) do
    _ = load_app()
    {:ok, _, _} = Migrator.with_repo(repo, &Migrator.run(&1, :down, to: version))
  end

  @doc false
  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  @doc false
  defp load_app do
    Application.load(@app)
  end
end
