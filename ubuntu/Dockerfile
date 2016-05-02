FROM krallin/ubuntu-tini:trusty
MAINTAINER Tim Lucas <tim@buildkite.com>

ARG BUILDKITE_AGENT_VERSION=stable

LABEL com.buildkite.distro="ubuntu" \
    com.buildkite.version=${BUILDKITE_AGENT_VERSION}

RUN apt-get update -yqq && apt-get install -y curl openssh-client git iptables aufs-tools \
    && apt-get clean

ENV BUILDKITE_AGENT_VERSION=${BUILDKITE_AGENT_VERSION} \
    BUILDKITE_BUILD_PATH=/buildkite/builds \
    BUILDKITE_HOOKS_PATH=/buildkite/hooks \
    BUILDKITE_PLUGINS_PATH=/buildkite/plugins

COPY ./scripts/docker/entrypoint.sh ./assets/ssh-env-config.sh /usr/local/bin/
COPY ./assets/${BUILDKITE_AGENT_VERSION}-amd64 /buildkite
RUN ln -s /buildkite/buildkite-agent /usr/local/bin/buildkite-agent

ENTRYPOINT ["/usr/local/bin/tini", "-vg", "--", "/usr/local/bin/entrypoint.sh", "buildkite-agent"]
CMD ["start"]
