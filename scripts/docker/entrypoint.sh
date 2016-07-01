#!/bin/bash -e

# Run a docker instance in the background if the DIND env is set
if [[ -n "$DIND" && "$DIND" != 'false' ]] ; then

  # Earlier versions of docker used -d rather than daemon
  if [[ $(docker --version | cut -d. -f2) -lt 10 ]] ; then
    cmd="-d"
  fi

  docker ${cmd:-daemon} $DOCKER_DAEMON_ARGS &
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

if grep Ubuntu /etc/os-release > /dev/null; then
  cat << EOF >&2
---
The Ubuntu versions of the buildkite/agent images are now deprecated and only
the Alpine version of the images are supported and updated.

Please migrate to the Alpine-based image, or if you’d like to use Ubuntu
please build your own Docker image and use the standard Buildkite Agent
installers.
---
EOF
fi

exec /usr/local/bin/ssh-env-config.sh "$@"
