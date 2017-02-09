FROM alpine:edge

RUN apk add --no-cache \
    tini \
    bash \
    git \
    perl \
    openssh-client \
    curl \
    docker \
    jq \
    su-exec

ENV BUILDKITE_BUILD_PATH=/buildkite/builds \
    BUILDKITE_HOOKS_PATH=/buildkite/hooks \
    BUILDKITE_PLUGINS_PATH=/buildkite/plugins

RUN curl -Lfs -o /usr/local/bin/buildkite-agent https://download.buildkite.com/agent/experimental/latest/buildkite-agent-linux-amd64 \
    && chmod +x /usr/local/bin/buildkite-agent \
    && mkdir -p /buildkite/builds /buildkite/hooks /buildkite/plugins \
    && curl -Lfs -o /usr/local/bin/ssh-env-config.sh https://raw.githubusercontent.com/buildkite/docker-ssh-env-config/master/ssh-env-config.sh \
    && chmod +x /usr/local/bin/ssh-env-config.sh

COPY ./compose.sh /usr/local/bin/docker-compose

VOLUME /buildkite
ENTRYPOINT ["/sbin/tini", "-g", "--", "ssh-env-config.sh", "buildkite-agent"]
