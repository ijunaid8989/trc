# Extend from the official Elixir image
FROM elixir:1.12 as build

RUN apt update && apt install -y python3-pip --upgrade
RUN apt install -y jq
RUN apt install -y git
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash && apt -y install nodejs

# Create app directory and copy the Elixir projects into it
RUN mkdir -p /opt/trc
WORKDIR /opt/trc
COPY . /opt/trc/

# Install hex package manager
# By using --force, we don’t need to type “Y” to confirm the installation
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get

RUN make release ENV=prod

# Application container
FROM ubuntu:20.04

RUN apt update && apt-get install openssh-server -y
RUN apt install -y python3-pip --upgrade
RUN apt install -y jq
RUN apt install -y git
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash && apt -y install nodejs

# Set the locale
RUN apt install -y locales
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN mkdir -p /opt/trc
WORKDIR /opt/trc

COPY --from=build /opt/trc/_build/prod/rel/trc ./

COPY deployment/start.sh /opt/trc/
RUN chown -R nobody: /opt/trc
USER nobody
RUN chmod u+x /opt/trc/start.sh

# Define default command.
ENTRYPOINT ["/opt/trc/start.sh"]
