FROM alpine:3.4

RUN apk add --no-cache \
      tini \
      bash \
      git \
      perl \
      openssh-client

ENV BUILDKITE_AGENT_VERSION 2.1.17

ADD https://download.buildkite.com/agent/stable/$BUILDKITE_AGENT_VERSION/buildkite-agent-linux-amd64 /usr/local/bin/buildkite-agent
RUN chmod +x /usr/local/bin/buildkite-agent

# In 3.0 this is built into the buildkite-agent binary
ADD https://raw.githubusercontent.com/buildkite/agent/v$BUILDKITE_AGENT_VERSION/templates/bootstrap.sh /buildkite/bootstrap.sh
RUN chmod +x /buildkite/bootstrap.sh

RUN mkdir -p \
      /buildkite/builds \
      /buildkite/hooks

ENV BUILDKITE_BUILD_PATH=/buildkite/builds \
    BUILDKITE_HOOKS_PATH=/buildkite/hooks \
    BUILDKITE_BOOTSTRAP_SCRIPT_PATH=/buildkite/bootstrap.sh

ADD https://raw.githubusercontent.com/buildkite/docker-ssh-env-config/master/ssh-env-config.sh /usr/local/bin/ssh-env-config.sh
RUN chmod +x /usr/local/bin/ssh-env-config.sh

ENTRYPOINT ["/sbin/tini", "-g", "--", "ssh-env-config.sh", "buildkite-agent"]
