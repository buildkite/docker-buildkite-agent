#!/bin/bash -e

# If we were given a PORT environment variable, start as a simple daemon;
# otherwise, spawn a shell as well
if [ "$PORT" ]
then
  exec docker -d -H 0.0.0.0:$PORT -H unix:///var/run/docker.sock \
    $DOCKER_DAEMON_ARGS
else
  if [ "$LOG" == "file" ]
  then
    docker -d $DOCKER_DAEMON_ARGS &>/var/log/docker.log &
  else
    docker -d $DOCKER_DAEMON_ARGS &
  fi
  (( timeout = 60 + SECONDS ))
  until docker info >/dev/null 2>&1
  do
    if (( SECONDS >= timeout )); then
      echo 'Timed out trying to connect to internal docker host.' >&2
      break
    fi
    sleep 1
  done
  [[ $1 ]] && exec "$@"
  exec bash --login
fi