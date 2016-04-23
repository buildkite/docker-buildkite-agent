FROM alpine:3.3
MAINTAINER Tim Lucas <tim@buildkite.com>

ARG BUILDKITE_AGENT_VERSION=stable

LABEL com.buildkite.distro="alpine" \
    com.buildkite.version=${BUILDKITE_AGENT_VERSION} \
    com.buildkite.docker_version=1.10.1 \
    com.buildkite.docker_compose_version=1.6.0

RUN apk add --update --repository http://dl-1.alpinelinux.org/alpine/edge/community/ tini docker\<1.10.2 \
     && apk add curl wget bash git perl openssh-client py-pip py-yaml \
    && pip install -U pip docker-compose==1.6.0 \
    && rm -rf /tmp/* /root/.cache `find / -regex '.*\.py[co]'`

ENV BUILDKITE_AGENT_VERSION=${BUILDKITE_AGENT_VERSION} \
    BUILDKITE_BUILD_PATH=/buildkite/builds \
    BUILDKITE_HOOKS_PATH=/buildkite/hooks

COPY ./scripts/docker/entrypoint.sh ./assets/ssh-env-config.sh /usr/local/bin/
COPY ./assets/${BUILDKITE_AGENT_VERSION}-amd64 /buildkite
RUN ln -s /buildkite/buildkite-agent /usr/local/bin/buildkite-agent

ENTRYPOINT ["/usr/bin/tini", "-vg", "--", "/usr/local/bin/entrypoint.sh", "buildkite-agent"]
CMD ["start"]
