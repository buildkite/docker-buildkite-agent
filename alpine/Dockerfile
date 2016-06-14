FROM alpine:3.4
MAINTAINER Tim Lucas <tim@buildkite.com>

ARG BUILDKITE_AGENT_VERSION=stable
ARG DOCKER_VERSION
ARG DOCKER_COMPOSE_VERSION

# Alpine sometimes has package revisions, check
# https://pkgs.alpinelinux.org/packages?name=docker
ARG ALPINE_DOCKER_REVISION=r0

LABEL com.buildkite.distro="alpine" \
    com.buildkite.version=${BUILDKITE_AGENT_VERSION} \
    com.buildkite.docker_version=${DOCKER_VERSION} \
    com.buildkite.docker_compose_version=${DOCKER_COMPOSE_VERSION}

RUN apk add --update --repository http://dl-cdn.alpinelinux.org/alpine/3.4/community/ docker=${DOCKER_VERSION}-${ALPINE_DOCKER_REVISION} \
    && apk add curl wget bash git perl openssh-client py-pip py-yaml \
    && pip install -U pip docker-compose==${DOCKER_COMPOSE_VERSION} \
    && rm -rf /tmp/* /root/.cache `find / -regex '.*\.py[co]'`

ENV BUILDKITE_AGENT_VERSION=${BUILDKITE_AGENT_VERSION} \
    BUILDKITE_BUILD_PATH=/buildkite/builds \
    BUILDKITE_HOOKS_PATH=/buildkite/hooks

COPY ./scripts/docker/entrypoint.sh ./assets/ssh-env-config.sh /usr/local/bin/
COPY ./assets/${BUILDKITE_AGENT_VERSION}-amd64 /buildkite
RUN ln -s /buildkite/buildkite-agent /usr/local/bin/buildkite-agent

ENTRYPOINT ["tini", "-g", "--", "/usr/local/bin/entrypoint.sh", "buildkite-agent"]
CMD ["start"]
