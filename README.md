# TRC

## Features

- All data has been published to a topic exchange topology with different routing key, bind to 3 queues.
- All messages from 3 different queues are being consumed through broawdway consumer.
- All data is being saved to DB, in 3 different tables as datasets
- Redis Server is being used for caching API data
- REST API only read from Redis for identical requests.
- REST API that is capable of filtering data by topic and can be paginated

## Installation

STEP1. `mix deps.get`
STEP2. make sure your RabbitMQ client is running as well as REDIS server
STEP3. `iex -S mix phx.server`, Consumers have already been started but you can either start even streamer from application tree or by hand. `TRC.Streamer.start_link(%{})`

Tests are added, and the API endpoint is `/v1/datasets`, which hits a VIEW in backend, I have union_all, all the 3 datasets on a topic name, so the API will have everything under dataset dashboard and can filter through topic name. Also sorting has been added as wel.

`Rmq Publisher` is being used for publishing the data events. Data is also being transfered to telemetry.

You can have multiple cache stores as Redis as well local. I am using `NebulexRedisAdapter` in dev for sake for demonstration, you can use `Nebulex.Adapters.Local` as well, which is being used in tests.