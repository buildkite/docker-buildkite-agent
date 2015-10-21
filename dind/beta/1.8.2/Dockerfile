FROM ubuntu:14.04

# Let's start with some basic stuff.
RUN apt-get update -qq && apt-get install -qqy \
    apt-transport-https \
    ca-certificates \
    iptables \
    curl \
    openssh-client \
    git

# Install Docker & Buildkite
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D && \
    echo 'deb https://apt.dockerproject.org/repo ubuntu-trusty main' > /etc/apt/sources.list.d/docker.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 32A37959C2FA5C3C99EFBC32A79206696452D198 && \
    echo 'deb https://apt.buildkite.com/buildkite-agent beta main' > /etc/apt/sources.list.d/buildkite-agent.list && \
    apt-get update -qq && \
    apt-get install -qqy docker-engine=1.8.2-0~trusty \
                         buildkite-agent

# Install the magic wrapper.
ADD https://raw.githubusercontent.com/docker/docker/v1.8.2/hack/dind /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/wrapdocker

# Install Docker Compose
RUN curl -L https://github.com/docker/compose/releases/download/1.4.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

RUN mkdir -p /buildkite/hooks /buildkite/builds /buildkite/plugins

ENV BUILDKITE_BUILD_PATH=/buildkite/builds \
    BUILDKITE_HOOKS_PATH=/buildkite/hooks \
    BUILDKITE_HOOKS_PATH=/buildkite/plugins

# Internal docker runs out of a volume
VOLUME /var/lib/docker

ENTRYPOINT ["wrapdocker","buildkite-agent"]
CMD ["start"]
