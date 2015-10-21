FROM ubuntu:14.04
MAINTAINER Tim Lucas <tim@buildkite.com>

# Install the essentials needed to add more apt repos, and any others
RUN apt-get update -qq && apt-get install -qqy \
    apt-transport-https \
    ca-certificates \
    curl \
    iptables \
    openssh-client \
    git

# Install Docker
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D && \
    echo 'deb https://apt.dockerproject.org/repo ubuntu-trusty main' > /etc/apt/sources.list.d/docker.list && \
    apt-get update -q && \
    apt-get install -q -y docker-engine=1.8.2-0~trusty

# Install Buildkite
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 32A37959C2FA5C3C99EFBC32A79206696452D198 && \
    echo 'deb https://apt.buildkite.com/buildkite-agent stable main' > /etc/apt/sources.list.d/buildkite-agent.list && \
    apt-get update -qq && \
    apt-get install -qqy buildkite-agent && \
    mkdir -p /buildkite/hooks /buildkite/builds /buildkite/plugins && \
    # Copy the bootstrap to /buildkite in case that's what people were expecting
    cp /usr/share/buildkite-agent/bootstrap.sh /buildkite/bootstrap.sh

# Install the magic wrapper
ADD https://raw.githubusercontent.com/docker/docker/v1.8.2/hack/dind /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/wrapdocker

# Install Docker Compose
RUN curl -L https://github.com/docker/compose/releases/download/1.4.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

ENV BUILDKITE_BOOTSTRAP_SCRIPT_PATH=/buildkite/bootstrap.sh \
    BUILDKITE_BUILD_PATH=/buildkite/builds \
    BUILDKITE_HOOKS_PATH=/buildkite/hooks

# Internal docker runs out of a volume
VOLUME /var/lib/docker

ENTRYPOINT ["wrapdocker","buildkite-agent"]
CMD ["start"]