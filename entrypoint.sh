#!/bin/bash

DIR=/docker-entrypoint.d

if [[ -d "$DIR" ]] ; then
  /bin/run-parts --verbose "$DIR"
fi

exec /sbin/tini -g -- ssh-env-config.sh /usr/local/bin/buildkite-agent "$@"