FROM gliderlabs/alpine:edge
MAINTAINER Tim Lucas <tim@buildkite.com>

ARG BUILDKITE_AGENT_VERSION=stable
ARG SSH_ENV_COMMIT_REF=bf7e6f0

LABEL com.buildkite.distro="alpine" \
    com.buildkite.version=${BUILDKITE_AGENT_VERSION} \
    com.buildkite.docker_version=1.9.1 \
    com.buildkite.docker_compose_version=1.5.1

RUN apk add --update --repository http://dl-1.alpinelinux.org/alpine/edge/testing/ tini \
     && apk-install curl wget bash git perl openssh-client py-pip py-yaml docker\<1.9.2 \
    && pip install -U pip docker-compose==1.5.1 \
    && rm -rf /tmp/* /root/.cache `find / -regex '.*\.py[co]'`

ENV BUILDKITE_AGENT_VERSION=${BUILDKITE_AGENT_VERSION} \
    BUILDKITE_BUILD_PATH=/buildkite/builds \
    BUILDKITE_HOOKS_PATH=/buildkite/hooks \
    PATH=$PATH:/buildkite/bin

COPY ./scripts/docker/* /tmp/
RUN ARCH=386 /tmp/install_buildkite.sh ${BUILDKITE_AGENT_VERSION} ${SSH_ENV_COMMIT_REF} \
    && cp /tmp/entrypoint.sh /usr/local/bin/entrypoint.sh \
    && rm -rf /tmp/*

ENTRYPOINT ["/usr/bin/tini", "-vg", "--", "/usr/local/bin/entrypoint.sh", "buildkite-agent"]
CMD ["start"]
