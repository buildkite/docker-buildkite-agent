FROM ubuntu:14.04
# BK-TAG: dind-1.6.2
# BK-PRIVILEGED

# https://github.com/docker/docker/blob/master/project/PACKAGERS.md#runtime-dependencies
RUN apt-get update -qq && apt-get install -qqy \
    apt-transport-https \
    ca-certificates \
    curl \
    lxc \
    iptables \
    openssh-client \
    git \
    --no-install-recommends && rm -rf /var/lib/apt/lists/*

ENV DIND_COMMIT=723d43387a5c04ef8588c7e1557aa163e268581c \
    DOCKER_BUCKET=get.docker.com \
    DOCKER_VERSION=1.6.2 \
    DOCKER_COMPOSE_VERSION=1.3.1

RUN curl -fL "https://raw.githubusercontent.com/docker/docker/${DIND_COMMIT}/hack/dind" -o /usr/local/sbin/dind \
    && chmod +x /usr/local/sbin/dind

RUN curl -fL "https://${DOCKER_BUCKET}/builds/Linux/x86_64/docker-${DOCKER_VERSION}" -o /usr/local/bin/docker \
    && chmod +x /usr/local/bin/docker

RUN curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" > /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

VOLUME /var/lib/docker
EXPOSE 2375

RUN DESTINATION=/buildkite bash -c \
    "`curl -sL https://raw.githubusercontent.com/buildkite/agent/master/install.sh`"

ENV PATH=$PATH:/buildkite/bin \
    BUILDKITE_BOOTSTRAP_SCRIPT_PATH=/buildkite/bootstrap.sh \
    BUILDKITE_BUILD_PATH=/buildkite/builds \
    BUILDKITE_HOOKS_PATH=/buildkite/hooks

ADD docker-entrypoint.sh /usr/local/sbin/docker-entrypoint.sh

ENTRYPOINT ["dind","docker-entrypoint.sh", "buildkite-agent"]
CMD ["start"]