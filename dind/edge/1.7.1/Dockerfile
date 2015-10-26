FROM ubuntu:14.04
# BK-TAG: edge-dind-1.7.1
# BK-PRIVILEGED

# https://github.com/docker/docker/blob/master/project/PACKAGERS.md#runtime-dependencies
RUN apt-get update -qq && apt-get install -qqy \
    apt-transport-https \
    ca-certificates \
    curl \
    lxc \
    iptables \
    openssh-client \
    git \
    --no-install-recommends && rm -rf /var/lib/apt/lists/*

ENV DIND_COMMIT=4e899d64e020a67ca05f913d354aa8d99a341a7b \
    DOCKER_BUCKET=get.docker.com \
    DOCKER_VERSION=1.7.1 \
    DOCKER_COMPOSE_VERSION=1.4.2 \
    SSH_ENV_CONFIG_COMMIT=eb13430a622a9cc35c6ec85a63c8595b67c8534f \
    BUILDKITE_AGENT_VERSION=edge \
    BUILDKITE_BUILD_PATH=/buildkite/builds \
    BUILDKITE_HOOKS_PATH=/buildkite/hooks \
    BUILDKITE_PLUGINS_PATH=/buildkite/plugins

RUN curl -fL "https://raw.githubusercontent.com/docker/docker/${DIND_COMMIT}/hack/dind" -o /usr/local/sbin/dind \
    && chmod +x /usr/local/sbin/dind \
    && curl -fL "https://${DOCKER_BUCKET}/builds/Linux/x86_64/docker-${DOCKER_VERSION}" -o /usr/local/bin/docker \
    && chmod +x /usr/local/bin/docker \
    && curl -fL "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose \
    && curl -fL "https://download.buildkite.com/builds/$(uname -s)/$(uname -m)/buildkite-agent-${BUILDKITE_AGENT_VERSION}" -o /usr/local/bin/buildkite-agent \
    && chmod +x /usr/local/bin/buildkite-agent \
    && curl -fL "https://raw.githubusercontent.com/buildkite/docker-ssh-env-config/${SSH_ENV_CONFIG_COMMIT}/ssh-env-config.sh" -o /usr/local/bin/ssh-env-config.sh \
    && chmod +x /usr/local/bin/ssh-env-config.sh

ADD docker-entrypoint.sh /usr/local/sbin/docker-entrypoint.sh

VOLUME /var/lib/docker
EXPOSE 2375

ENTRYPOINT ["dind","docker-entrypoint.sh","ssh-env-config.sh","buildkite-agent"]
CMD ["start"]
