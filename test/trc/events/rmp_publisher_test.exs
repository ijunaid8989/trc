defmodule TRC.Events.RmqPublisherTest do
  use ExUnit.Case

  import TRC.TestUtils

  alias GenRMQ.Publisher
  alias TRC.Events
  alias TRC.Events.RmqPublisher

  @event [:int, :events, :publish, :stop]

  describe "child_spec/1" do
    test "ok: returns the child spec" do
      assert RmqPublisher.child_spec([]) == %{
               id: TRC.Events.RmqPublisher,
               start: {GenRMQ.Publisher, :start_link, [TRC.Events.RmqPublisher, []]}
             }
    end
  end

  describe "c:init/0" do
    test "ok: publisher starts" do
      with_telemetry_handler([@event], fn ->
        assert {:ok, publisher} = Publisher.start_link(RmqPublisher, name: __MODULE__)
        assert {:ok, pid} = Events.start_link(name: :rmq_publisher_test, publisher: publisher)

        assert Events.publish(pid, "twitch", %{}) == :ok

        assert_receive {@event, %{duration: _}, meta}, 10_000
        assert meta[:routing_key] == "twitch.events.data"
        assert meta[:result] == :ok
      end)
    end
  end
end
