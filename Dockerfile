FROM gliderlabs/alpine:3.2
MAINTAINER Tim Lucas <tim@buildkite.com>
# BK-TAG: latest

ENV DOCKER_COMPOSE_VERSION=1.4.2 \
    BUILDKITE_AGENT_VERSION=edge \
    BUILDKITE_BUILD_PATH=/buildkite/builds \
    BUILDKITE_HOOKS_PATH=/buildkite/hooks \
    BUILDKITE_BOOTSTRAP_SCRIPT_PATH=/buildkite/bootstrap.sh \
    PATH=$PATH:/buildkite/bin

RUN apk-install curl wget bash git perl openssh-client py-pip py-yaml \
    && pip install -U pip docker-compose==${DOCKER_COMPOSE_VERSION} \
    && DESTINATION=/buildkite bash -c "`curl -sL https://raw.githubusercontent.com/buildkite/agent/master/install.sh`" \
    && rm -rf \
      # Clean up any temporary files:
      /tmp/* \
      # Clean up the pip cache:
      /root/.cache \
      # Remove any compiled python files (compile on demand):
      `find / -regex '.*\.py[co]'`

ENTRYPOINT ["buildkite-agent"]
CMD ["start"]
