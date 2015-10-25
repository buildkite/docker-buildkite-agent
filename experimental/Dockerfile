FROM gliderlabs/alpine:3.2
MAINTAINER Tim Lucas <tim@buildkite.com>
# BK-TAG: experimental

ENV DOCKER_COMPOSE_VERSION=1.4.2 \
    BUILDKITE_AGENT_VERSION=master \
    BUILDKITE_BUILD_PATH=/buildkite/builds \
    BUILDKITE_HOOKS_PATH=/buildkite/hooks \
    BUILDKITE_PLUGINS_PATH=/buildkite/plugins

RUN apk-install curl wget bash git perl openssh-client py-pip py-yaml \
    && pip install -U pip docker-compose==${DOCKER_COMPOSE_VERSION} \
    && curl -fL "https://download.buildkite.com/builds/Linux/386/buildkite-agent-${BUILDKITE_AGENT_VERSION}" -o /usr/local/bin/buildkite-agent \
    && chmod +x /usr/local/bin/buildkite-agent \
    && rm -rf \
      # Clean up any temporary files:
      /tmp/* \
      # Clean up the pip cache:
      /root/.cache \
      # Remove any compiled python files (compile on demand):
      `find / -regex '.*\.py[co]'`

ENTRYPOINT ["buildkite-agent"]
CMD ["start"]
