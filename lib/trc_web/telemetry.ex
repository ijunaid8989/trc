defmodule TRCWeb.Telemetry do
  use Supervisor
  import Telemetry.Metrics

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    children = [
      # Telemetry poller will execute the given period measurements
      # every 10_000ms. Learn more here: https://hexdocs.pm/telemetry_metrics
      {:telemetry_poller, measurements: periodic_measurements(), period: 10_000}
      # Add reporters as children of your supervision tree.
      # {Telemetry.Metrics.ConsoleReporter, metrics: metrics()}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def metrics do
    [
      # Phoenix Metrics
      summary("phoenix.endpoint.stop.duration",
        unit: {:native, :millisecond}
      ),
      summary("phoenix.router_dispatch.stop.duration",
        tags: [:route],
        unit: {:native, :millisecond}
      ),

      # Redis cache stats
      last_value("cache.stats.hits", tags: [:env, :otp_app, :cache]),
      last_value("cache.stats.misses", tags: [:env, :otp_app, :cache]),
      last_value("cache.stats.writes", tags: [:env, :otp_app, :cache]),
      last_value("cache.stats.updates", tags: [:env, :otp_app, :cache]),
      last_value("cache.stats.evictions", tags: [:env, :otp_app, :cache]),
      last_value("cache.stats.expirations", tags: [:env, :otp_app, :cache]),
      last_value("cache.info.size", tags: [:env, :otp_app, :cache]),

      # Redis cache commands
      summary("cache.command.stop.duration",
        unit: {:native, :millisecond},
        tags: [:env, :otp_app, :function_name]
      ),
      summary("cache.command.exception.duration",
        unit: {:native, :millisecond},
        tags: [:env, :otp_app, :function_name]
      ),

      # Local cache stats
      last_value("cache.local.stats.hits", tags: [:env, :otp_app, :cache]),
      last_value("cache.local.stats.misses", tags: [:env, :otp_app, :cache]),
      last_value("cache.local.stats.writes", tags: [:env, :otp_app, :cache]),
      last_value("cache.local.stats.updates", tags: [:env, :otp_app, :cache]),
      last_value("cache.local.stats.evictions", tags: [:env, :otp_app, :cache]),
      last_value("cache.local.stats.expirations", tags: [:env, :otp_app, :cache]),
      last_value("cache.local.info.size", tags: [:env, :otp_app, :cache]),

      # Database Metrics
      summary("trc.repo.query.total_time",
        unit: {:native, :millisecond},
        description: "The sum of the other measurements"
      ),
      summary("trc.repo.query.decode_time",
        unit: {:native, :millisecond},
        description: "The time spent decoding the data received from the database"
      ),
      summary("trc.repo.query.query_time",
        unit: {:native, :millisecond},
        description: "The time spent executing the query"
      ),
      summary("trc.repo.query.queue_time",
        unit: {:native, :millisecond},
        description: "The time spent waiting for a database connection"
      ),
      summary("trc.repo.query.idle_time",
        unit: {:native, :millisecond},
        description:
          "The time the connection spent waiting before being checked out for the query"
      ),

      # VM Metrics
      summary("vm.memory.total", unit: {:byte, :kilobyte}),
      summary("vm.total_run_queue_lengths.total"),
      summary("vm.total_run_queue_lengths.cpu"),
      summary("vm.total_run_queue_lengths.io")
    ]
  end

  defp periodic_measurements do
    [
      {TRC.Cache, :dispatch_stats, []},
      {TRC.Cache, :dispatch_cache_info, []},
      {TRC.Cache.Local, :dispatch_stats, []},
      {TRC.Cache.Local, :dispatch_cache_info, []}
    ]
  end
end
