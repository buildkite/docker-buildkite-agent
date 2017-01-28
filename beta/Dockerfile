FROM alpine:3.4

RUN apk add --no-cache \
      tini \
      bash \
      git \
      perl \
      openssh-client

ENV BUILDKITE_AGENT_VERSION 3.0-beta.9

ADD https://download.buildkite.com/agent/unstable/$BUILDKITE_AGENT_VERSION/buildkite-agent-linux-amd64 /usr/local/bin/buildkite-agent
RUN chmod +x /usr/local/bin/buildkite-agent

RUN mkdir -p \
      /buildkite/builds \
      /buildkite/hooks \
      /buildkite/plugins

ENV BUILDKITE_BUILD_PATH=/buildkite/builds \
    BUILDKITE_HOOKS_PATH=/buildkite/hooks \
    BUILDKITE_PLUGINS_PATH=/buildkite/plugins

ADD https://raw.githubusercontent.com/buildkite/docker-ssh-env-config/master/ssh-env-config.sh /usr/local/bin/ssh-env-config.sh
RUN chmod +x /usr/local/bin/ssh-env-config.sh

ENTRYPOINT ["/sbin/tini", "-g", "--", "ssh-env-config.sh", "buildkite-agent"]
