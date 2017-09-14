FROM alpine:3.6

RUN apk add --no-cache \
    tini \
    bash \
    git \
    perl \
    rsync \
    openssh-client \
    curl \
    docker \
    jq \
    su-exec \
    py-pip \
    libc6-compat \
    run-parts

ENV BUILDKITE_BUILD_PATH=/buildkite/builds \
    BUILDKITE_HOOKS_PATH=/buildkite/hooks \
    BUILDKITE_BOOTSTRAP_SCRIPT_PATH=/buildkite/bootstrap.sh

RUN pip install docker-compose

RUN curl -Lfs -o /usr/local/bin/buildkite-agent https://download.buildkite.com/agent/stable/latest/buildkite-agent-linux-amd64 \
    && chmod +x /usr/local/bin/buildkite-agent \
    && mkdir -p /buildkite/builds /buildkite/hooks \
    && curl -Lfs -o /usr/local/bin/ssh-env-config.sh https://raw.githubusercontent.com/buildkite/docker-ssh-env-config/master/ssh-env-config.sh \
    && chmod +x /usr/local/bin/ssh-env-config.sh

# In 3.0 this is built into the buildkite-agent binary
RUN curl -Lfs -o /buildkite/bootstrap.sh https://raw.githubusercontent.com/buildkite/agent/2-1-stable/templates/bootstrap.sh \
    && chmod +x /buildkite/bootstrap.sh

COPY ./entrypoint.sh /usr/local/bin/buildkite-agent-entrypoint

VOLUME /buildkite
ENTRYPOINT ["buildkite-agent-entrypoint"]
CMD ["start"]
