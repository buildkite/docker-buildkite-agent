FROM ubuntu
MAINTAINER Tim Lucas <tim@buildkite.com>

# Install buildkite-agent
RUN apt-get install -y apt-transport-https curl

RUN echo deb https://apt.buildkite.com/buildkite-agent unstable main > /etc/apt/sources.list.d/buildkite-agent.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 32A37959C2FA5C3C99EFBC32A79206696452D198

RUN apt-get update && \
    apt-get install -y apt-transport-https \
                       buildkite-agent

RUN mkdir -p /var/buildkite-agent/builds

# Install Docker-Compose
RUN curl -L https://github.com/docker/compose/releases/download/1.2.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

ENV BUILDKITE_BOOTSTRAP_SCRIPT_PATH="/etc/buildkite-agent/bootstrap.sh" \
    BUILDKITE_HOOKS_PATH="/etc/buildkite-agent/hooks" \
    BUILDKITE_BUILD_PATH="/var/buildkite-agent/builds"

CMD ["buildkite-agent", "start"]
