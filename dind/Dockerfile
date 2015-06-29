FROM jpetazzo/dind
MAINTAINER Lachlan Donald <lachlan@99designs.com>

RUN apt-get install -y curl openssh-client git && \
    curl -L https://get.docker.com/builds/Linux/x86_64/docker-1.6.2 > /usr/local/bin/docker && \
    curl -L https://github.com/docker/compose/releases/download/1.3.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker /usr/local/bin/docker-compose && \
    BETA="true" DESTINATION=/buildkite bash -c "`curl -sL https://raw.githubusercontent.com/buildkite/agent/master/install.sh`"

ENV PATH=$PATH:/buildkite/bin \
    BUILDKITE_BOOTSTRAP_SCRIPT_PATH=/buildkite/bootstrap.sh \
    BUILDKITE_BUILD_PATH=/buildkite/builds \
    BUILDKITE_HOOKS_PATH=/buildkite/hooks

ENTRYPOINT ["wrapdocker","buildkite-agent"]
CMD ["start"]