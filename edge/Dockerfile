FROM gliderlabs/alpine:3.2
MAINTAINER Tim Lucas <tim@buildkite.com>
# BK-TAG: edge

ENV DOCKER_COMPOSE_VERSION=1.4.2 \
    BUILDKITE_AGENT_VERSION=edge \
    BUILDKITE_BUILD_PATH=/buildkite/builds \
    BUILDKITE_HOOKS_PATH=/buildkite/hooks \
    BUILDKITE_PLUGINS_PATH=/buildkite/plugins

RUN apk-install curl wget bash git perl openssh-client py-pip py-yaml \
    # Install docker-compose via pip because binary doesn't work on Alpine
    && pip install -U pip docker-compose==${DOCKER_COMPOSE_VERSION} \
    # Install buildkite-agent
    && curl -fL "https://download.buildkite.com/builds/Linux/386/buildkite-agent-${BUILDKITE_AGENT_VERSION}" -o /usr/local/bin/buildkite-agent \
    && chmod +x /usr/local/bin/buildkite-agent \
    # Install the SSH config wrapper
    && curl -fL "https://raw.githubusercontent.com/buildkite/container-tools/master/ssh-env-config/ssh-env-config.sh" -o /usr/local/bin/ssh-env-config.sh \
    && chmod +x /usr/local/bin/ssh-env-config.sh \
    # Clean up
    && rm -rf \
      # Pip cache
      /root/.cache \
      # Compiled python files
      `find / -regex '.*\.py[co]'`

ENTRYPOINT ["ssh-env-config.sh","buildkite-agent"]
CMD ["start"]
