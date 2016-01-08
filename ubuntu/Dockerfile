FROM ubuntu-debootstrap:14.04
MAINTAINER Tim Lucas <tim@buildkite.com>

ARG BUILDKITE_AGENT_VERSION=stable
LABEL com.buildkite.distro="ubuntu" \
    com.buildkite.version=${BUILDKITE_AGENT_VERSION}

RUN apt-get update -yqq && apt-get install -y curl openssh-client git iptables aufs-tools \
    && apt-get clean

ENV BUILDKITE_AGENT_VERSION=${BUILDKITE_AGENT_VERSION} \
    BUILDKITE_BUILD_PATH=/buildkite/builds \
    BUILDKITE_HOOKS_PATH=/buildkite/hooks \
    BUILDKITE_PLUGINS_PATH=/buildkite/plugins \
    PATH=$PATH:/buildkite/bin

COPY ./scripts/docker/* /tmp/
RUN /tmp/install_buildkite.sh ${BUILDKITE_AGENT_VERSION} \
    && cp /tmp/entrypoint.sh /usr/local/bin/entrypoint.sh \
    && rm -rf /tmp/*

ENTRYPOINT ["/usr/local/bin/entrypoint.sh", "buildkite-agent"]
CMD ["start"]
