defmodule TRC.EventsTest do
  use TRC.DataCase

  import TRC.TestUtils
  import Mock

  alias TRC.Events
  alias TRC.Events.RmqPublisher

  @prefix [:int, :events, :publish]
  @start @prefix ++ [:start]
  @stop @prefix ++ [:stop]
  @events [@start, @stop]

  setup do
    {:ok, pid} = Events.start_link(name: __MODULE__, publisher: RmqPublisher)

    on_exit(fn ->
      if Process.alive?(pid), do: GenServer.stop(pid, :normal)
    end)

    twitch = %{
      channel: "some channel",
      language: "some language",
      mature: true,
      metadata: %{
        watch_time: 345,
        stream_time: 345,
        peak_viewers: 345,
        average_viewers: 345,
        followers: 345,
        followers_gained: 345,
        views_gained: 345
      },
      partnered: true
    }

    {:ok, [pid: pid, twitch: twitch]}
  end

  describe "publish/2" do
    test_with_mock "ok: twitch event is published",
                   %{twitch: twitch, pid: pid},
                   GenRMQ.Publisher,
                   [:passthrough],
                   publish: fn _, _, _ -> :ok end do
      with_telemetry_handler(@events, fn ->
        assert Events.publish(pid, "twitch", twitch) == :ok

        assert_receive {@start, %{system_time: _}, %{routing_key: "twitch.events.data"}}, 5000

        assert_receive {@stop, %{duration: _}, meta}, 5000
        assert meta[:routing_key] == "twitch.events.data"
        assert meta[:result] == :ok
        assert meta[:reason] == :ok
      end)
    end

    test_with_mock "ok: memegen event with empty map is published",
                   %{pid: pid},
                   GenRMQ.Publisher,
                   [:passthrough],
                   publish: fn _, _, _ -> :ok end do
      with_telemetry_handler(@events, fn ->
        assert Events.publish(pid, "memegen", %{}) == :ok

        assert_receive {@start, %{system_time: _}, %{routing_key: "memegen.events.data"}}, 5000

        assert_receive {@stop, %{duration: _}, meta}, 5000
        assert meta[:routing_key] == "memegen.events.data"
        assert meta[:result] == :ok
        assert meta[:reason] == :ok
      end)
    end

    test_with_mock "error: message is not published",
                   %{twitch: twitch, pid: pid},
                   GenRMQ.Publisher,
                   [:passthrough],
                   publish: fn _, _, _ -> {:error, :blocked} end do
      with_telemetry_handler(@events, fn ->
        assert Events.publish(pid, "twitch", twitch) == :ok

        assert_receive {@start, %{system_time: _}, %{routing_key: "twitch.events.data"}}, 5000

        assert_receive {@stop, %{duration: _}, meta}, 5000
        assert meta[:routing_key] == "twitch.events.data"
        assert meta[:result] == :error
        assert meta[:reason] == :blocked
      end)
    end

    test_with_mock "error: timeout",
                   %{twitch: twitch, pid: pid},
                   GenRMQ.Publisher,
                   [:passthrough],
                   publish: fn _, _, _ -> exit({:timeout, {GenServer, :call, []}}) end do
      with_telemetry_handler(@events, fn ->
        assert Events.publish(pid, "twitch", twitch) == :ok

        assert_receive {@start, %{system_time: _}, %{routing_key: "twitch.events.data"}}, 5000

        assert_receive {@stop, %{duration: _}, meta}, 5000
        assert meta[:routing_key] == "twitch.events.data"
        assert meta[:result] == :error
        assert meta[:reason] == :timeout
      end)
    end
  end
end
