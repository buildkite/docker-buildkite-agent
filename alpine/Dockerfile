FROM gliderlabs/alpine:3.2
MAINTAINER Tim Lucas <tim@buildkite.com>

RUN apk-install curl wget bash git perl openssh-client \
    && rm -rf /var/cache/apk/* /root/.cache

ARG BUILDKITE_AGENT_VERSION=stable
ENV BUILDKITE_AGENT_VERSION=${BUILDKITE_AGENT_VERSION} \
    BUILDKITE_BUILD_PATH=/buildkite/builds \
    BUILDKITE_HOOKS_PATH=/buildkite/hooks \
    BUILDKITE_BOOTSTRAP_SCRIPT_PATH=/buildkite/bootstrap.sh \
    PATH=$PATH:/buildkite/bin

COPY ./scripts/docker/* /tmp/
RUN /tmp/install_buildkite.sh ${BUILDKITE_AGENT_VERSION} \
    && rm -rf /tmp/*

ENTRYPOINT ["/usr/local/bin/ssh-env-config.sh", "buildkite-agent"]
CMD ["start"]
