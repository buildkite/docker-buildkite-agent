FROM alpine:edge

RUN apk add --no-cache \
    tini \
    bash \
    git \
    perl \
    openssh-client \
    curl \
    docker \
    docker-compose \
    jq \
    su-exec

ENV BUILDKITE_AGENT_VERSION=3.0-beta.9 \
    BUILDKITE_BUILD_PATH=/buildkite/builds \
    BUILDKITE_HOOKS_PATH=/buildkite/hooks \
    BUILDKITE_PLUGINS_PATH=/buildkite/plugins

RUN curl -Lfs -o /usr/local/bin/buildkite-agent https://download.buildkite.com/agent/unstable/$BUILDKITE_AGENT_VERSION/buildkite-agent-linux-amd64 \
    && chmod +x /usr/local/bin/buildkite-agent \
    && mkdir -p /buildkite/builds /buildkite/hooks /buildkite/plugins \
    && curl -Lfs -o /usr/local/bin/ssh-env-config.sh https://raw.githubusercontent.com/buildkite/docker-ssh-env-config/master/ssh-env-config.sh \
    && chmod +x /usr/local/bin/ssh-env-config.sh

ENTRYPOINT ["/sbin/tini", "-g", "--", "ssh-env-config.sh", "/usr/local/bin/buildkite-agent"]
