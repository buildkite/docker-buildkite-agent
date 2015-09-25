FROM ubuntu:14.04

# Let's start with some basic stuff.
RUN apt-get update -qq && apt-get install -qqy \
    apt-transport-https \
    ca-certificates \
    curl \
    iptables \
    curl \
    openssh-client \
    git

# Install Docker
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D && \
    echo 'deb https://apt.dockerproject.org/repo ubuntu-trusty main' > /etc/apt/sources.list.d/docker.list && \
    apt-get update -q && \
    apt-get install -q -y docker-engine=1.8.2-0~trusty

# Install the magic wrapper.
ADD https://raw.githubusercontent.com/docker/docker/v1.8.2/hack/dind /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/wrapdocker

# Install Docker Compose
RUN curl -L https://github.com/docker/compose/releases/download/1.4.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

# Install Buildkite
RUN DESTINATION=/buildkite bash -c \
    "`curl -sL https://raw.githubusercontent.com/buildkite/agent/master/install.sh`"

ENV PATH=$PATH:/buildkite/bin \
    BUILDKITE_BOOTSTRAP_SCRIPT_PATH=/buildkite/bootstrap.sh \
    BUILDKITE_BUILD_PATH=/buildkite/builds \
    BUILDKITE_HOOKS_PATH=/buildkite/hooks

# Internal docker runs out of a volume
VOLUME /var/lib/docker

ENTRYPOINT ["wrapdocker","buildkite-agent"]
CMD ["start"]