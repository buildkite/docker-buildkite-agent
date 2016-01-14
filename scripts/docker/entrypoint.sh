#!/bin/bash -e

# Run a docker instance in the background if the DIND env is set
if [[ -n "$DIND" && "$DIND" != 'false' ]] ; then
  docker -d $DOCKER_DAEMON_ARGS &
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
if [[ -f /buildkite/bootstrap.sh ]] ; then
  export BUILDKITE_BOOTSTRAP_SCRIPT_PATH=/buildkite/bootstrap.sh
fi

exec /usr/local/bin/ssh-env-config.sh "$@"