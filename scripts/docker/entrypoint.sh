#!/bin/bash -e


# Returns whether a version number (x.x.x) is greater than another
version_gt() {
  test "$(echo "$@" | tr " " "\n" | sort -V | tail -n 1)" == "$1"
}

# Run a docker instance in the background if the DIND env is set
if [[ -n "$DIND" && "$DIND" != 'false' ]] ; then
  docker_version=$(docker --version | awk '{print $3}' | sed 's/,//')
  groupadd docker
  usermod -a -G docker buildkite-agent

  # Docker daemon changed from -d to daemon
  if version_gt $docker_version "1.8.0" ; then
    docker daemon -G docker $DOCKER_DAEMON_ARGS &
  else
    docker -d -G docker $DOCKER_DAEMON_ARGS &
  fi

  (( timeout = ${DIND_START_TIMEOUT:-10} + SECONDS ))
  until docker info >/dev/null 2>&1 ; do
    if (( SECONDS >= timeout )); then
      echo 'Timed out trying to connect to internal docker host.' >&2
      exit 1
    fi
    sleep 1
  done
fi

# Older buildkite versions used a bash bootstrap
if [[ -e /buildkite/bootstrap.sh ]] ; then
  export BUILDKITE_BOOTSTRAP_SCRIPT_PATH=/buildkite/bootstrap.sh
fi

# Run the remainder as the buildkite-agent user
exec sudo --preserve-env -H -u buildkite-agent /usr/local/bin/ssh-env-config.sh "$@"