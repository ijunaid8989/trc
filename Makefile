PROJECT_NAME=trc
APP_NAME=$(PROJECT_NAME)-app

BASE_DIR=$(PWD)

ENV=dev

.PHONY: deps compile test check setup_db dbmigrate shell release \
				docker_build docker_up docker_down docker_bash

# Fetch dependencies
deps:
	mix deps.get

# Compile deps and project
compile: deps
	MIX_ENV=$(ENV) mix compile --warnings-as-errors

# Run tests with coverage
test:
	MIX_ENV=test mix test

# Run required checks
check: compile test
	mix format --check-formatted
	MIX_ENV=$(ENV) mix credo --strict

# Setup database from scratch
setup_db:
	MIX_ENV=$(ENV) mix ecto.create
	MIX_ENV=$(ENV) mix ecto.migrate
	MIX_ENV=$(ENV) mix run priv/repo/seeds.exs

# Ensure DB is created and migrations up to date
dbmigrate:
	MIX_ENV=$(ENV) mix ecto.create
	MIX_ENV=$(ENV) mix ecto.migrate

# Start trc in shell mode
shell: deps
	MIX_ENV=$(ENV) iex -S mix phx.server

# Generate release
release: deps
	mix phx.digest
	MIX_ENV=$(ENV) mix release

## Docker

# Build docker image
docker_build:
	docker build -t trc_app .

# Run docker-compose
docker_up:
	docker-compose up -d

# Stop docker-compose
docker_down:
	docker-compose down

# Bash mode
docker_bash:
	docker exec -it trc_app_1 bash
