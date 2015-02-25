FROM ubuntu
MAINTAINER Tim Lucas <tim@buildkite.com>

RUN apt-get install -y apt-transport-https curl

RUN echo deb https://apt.buildkite.com/buildkite-agent unstable main > /etc/apt/sources.list.d/buildkite-agent.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 32A37959C2FA5C3C99EFBC32A79206696452D198

RUN apt-get update && \
    apt-get install -y apt-transport-https \
                       buildkite-agent

RUN mkdir /builds
RUN cp -r /etc/buildkite-agent/hooks /hooks

ENV BUILDKITE_USER="root" \
    BUILDKITE_USER_GROUP="root" \
    BUILDKITE_BOOTSTRAP_SCRIPT_PATH="/etc/buildkite-agent/bootstrap.sh" \
    BUILDKITE_HOOKS_PATH="/etc/buildkite-agent/hooks" \
    BUILDKITE_BUILD_PATH="/builds" \
    BUILDKITE_BIN_PATH="/usr/bin" \
    BUILDKITE_AGENT_DEBUG="true"

CMD ["buildkite-agent", "start"]
