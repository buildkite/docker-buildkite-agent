FROM ubuntu:14.04
MAINTAINER Tim Lucas <tim@buildkite.com>
# BK-TAG: edge-ubuntu

ENV DOCKER_COMPOSE_VERSION=1.4.2 \
    BUILDKITE_AGENT_VERSION=edge \
    BUILDKITE_BUILD_PATH=/buildkite/builds \
    BUILDKITE_HOOKS_PATH=/buildkite/hooks \
    BUILDKITE_PLUGINS_PATH=/buildkite/plugins

RUN apt-get install -y curl openssh-client git \
    && curl -fL "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose \
    && curl -fL "https://download.buildkite.com/builds/$(uname -s)/$(uname -m)/buildkite-agent-${BUILDKITE_AGENT_VERSION}" -o /usr/local/bin/buildkite-agent \
    && chmod +x /usr/local/bin/buildkite-agent \
    && curl -fL "https://raw.githubusercontent.com/buildkite/docker-ssh-env-config/master/ssh-env-config.sh" -o /usr/local/bin/ssh-env-config.sh \
    && chmod +x /usr/local/bin/ssh-env-config.sh

ENTRYPOINT ["ssh-env-config.sh","buildkite-agent"]
CMD ["start"]
