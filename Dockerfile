FROM gliderlabs/alpine:3.1
MAINTAINER Tim Lucas <tim@buildkite.com>

RUN apk --update add curl wget bash git perl openssh-client && \
    curl -L https://github.com/docker/compose/releases/download/1.4.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

RUN DESTINATION=/buildkite bash -c "`curl -sL https://raw.githubusercontent.com/buildkite/agent/master/install.sh`"

ENV PATH=$PATH:/buildkite/bin \
    BUILDKITE_BOOTSTRAP_SCRIPT_PATH=/buildkite/bootstrap.sh \
    BUILDKITE_BUILD_PATH=/buildkite/builds \
    BUILDKITE_HOOKS_PATH=/buildkite/hooks

ENTRYPOINT ["buildkite-agent"]
CMD ["start"]
