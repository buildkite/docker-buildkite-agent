FROM ubuntu
MAINTAINER Tim Lucas <tim@buildkite.com>

RUN apt-get install -y curl openssh-client git

RUN curl -L https://github.com/docker/compose/releases/download/1.2.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

RUN BETA="true" DESTINATION=/buildkite bash -c "`curl -sL https://raw.githubusercontent.com/buildkite/agent/master/install.sh`"
ENV PATH $PATH:/buildkite/bin

ENV BUILDKITE_BOOTSTRAP_SCRIPT_PATH=/buildkite/bootstrap.sh \
    BUILDKITE_BUILD_PATH=/buildkite/builds \
    BUILDKITE_HOOKS_PATH=/buildkite/hooks

ENTRYPOINT ["buildkite-agent"]
CMD ["start"]
