FROM ubuntu:14.04
MAINTAINER Tim Lucas <tim@buildkite.com>

# Install the essentials needed to add more apt repos, and any others
RUN apt-get update -qq && apt-get install -qqy \
    apt-transport-https \
    ca-certificates \
    curl \
    lxc \
    iptables \
    openssh-client \
    git

# Install Docker & Buildkite
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9 && \
    echo 'deb https://get.docker.com/ubuntu docker main' > /etc/apt/sources.list.d/docker.list && \
    apt-get update -q && \
    apt-get install -q -y lxc-docker-1.7.0 && \
    DESTINATION=/buildkite bash -c "`curl -sL https://raw.githubusercontent.com/buildkite/agent/master/install.sh`"

# Install the magic wrapper
ADD https://raw.githubusercontent.com/jpetazzo/dind/master/wrapdocker /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/wrapdocker

# Install Docker Compose
RUN curl -L https://github.com/docker/compose/releases/download/1.3.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

ENV PATH=$PATH:/buildkite/bin \
    BUILDKITE_BOOTSTRAP_SCRIPT_PATH=/buildkite/bootstrap.sh \
    BUILDKITE_BUILD_PATH=/buildkite/builds \
    BUILDKITE_HOOKS_PATH=/buildkite/hooks

# Internal docker runs out of a volume
VOLUME /var/lib/docker

ENTRYPOINT ["wrapdocker","buildkite-agent"]
CMD ["start"]