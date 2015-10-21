FROM ubuntu:14.04
MAINTAINER Tim Lucas <tim@buildkite.com>

# Install the essentials needed to add more apt repos, and any others
RUN apt-get update -qq && apt-get install -qqy \
    apt-transport-https \
    ca-certificates \
    curl \
    openssh-client \
    git

# Install Buildkite
#
# The buildkite-agent apt source points to 'stable' instead of 'unstable'
# because unstable is currently broken, and there's no other unstable releases
# since v2.1.4
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 32A37959C2FA5C3C99EFBC32A79206696452D198 && \
    echo 'deb https://apt.buildkite.com/buildkite-agent stable main' > /etc/apt/sources.list.d/buildkite-agent.list && \
    apt-get update -qq && \
    apt-get install -y buildkite-agent && \
    mkdir -p /buildkite/hooks /buildkite/builds /buildkite/plugins

# Copy the bootstrap to /buildkite in case that's what people were expecting
RUN cp /usr/share/buildkite-agent/bootstrap.sh /buildkite/bootstrap.sh

ENV BUILDKITE_BOOTSTRAP_SCRIPT_PATH=/buildkite/bootstrap.sh \
    BUILDKITE_BUILD_PATH=/buildkite/builds \
    BUILDKITE_HOOKS_PATH=/buildkite/hooks \
    BUILDKITE_PLUGINS_PATH=/buildkite/plugins

ENTRYPOINT ["buildkite-agent"]
CMD ["start"]
