#!/bin/bash -e

: ${DOCKER_STORAGE_DRIVER="vfs"}
: ${DOCKER_DAEMON_ARGS="--storage-driver=$DOCKER_STORAGE_DRIVER -H unix:///var/run/docker.sock"}

docker -d $DOCKER_DAEMON_ARGS &

(( timeout = 60 + SECONDS ))
until docker info >/dev/null 2>&1
do
  if (( SECONDS >= timeout )); then
    echo 'Timed out trying to connect to internal docker host.' >&2
    exit 1
  fi
  sleep 1
done

[[ $1 ]] && exec "$@"