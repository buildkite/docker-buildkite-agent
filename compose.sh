#!/bin/bash
#
# Run docker-compose in a container
#
# Looks for $BUILDKITE_VOLUME with a volume to mount on /buildkite
#
set -euo pipefail

IMAGE="docker/compose:${COMPOSE_VERSION:-1.10.0}"
DOCKER_RUN_OPTIONS=""
DOCKER_HOST=""
DOCKER_ADDR=""

if [[ -z "${BUILDKITE_VOLUME:-}" ]] ; then
    echo "Expected a volume passed in via BUILDKITE_VOLUME"
    exit 1
fi

# Setup options for connecting to docker host
if [ -z "$DOCKER_HOST" ]; then
    DOCKER_HOST="/var/run/docker.sock"
fi
if [ -S "$DOCKER_HOST" ]; then
    DOCKER_ADDR="-v $DOCKER_HOST:$DOCKER_HOST -e DOCKER_HOST"
else
    DOCKER_ADDR="-e DOCKER_HOST -e DOCKER_TLS_VERIFY -e DOCKER_CERT_PATH"
fi

# Only allocate tty if we detect one
if [ -t 1 ]; then
    DOCKER_RUN_OPTIONS="-t"
fi
if [ -t 0 ]; then
    DOCKER_RUN_OPTIONS="$DOCKER_RUN_OPTIONS -i"
fi

exec docker run --rm $DOCKER_RUN_OPTIONS $DOCKER_ADDR -v "$BUILDKITE_VOLUME":/buildkite -w "$(pwd)" "$IMAGE" "$@"
