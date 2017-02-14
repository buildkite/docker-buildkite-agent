#!/bin/bash
exec /sbin/tini -g -- ssh-env-config.sh /usr/local/bin/buildkite-agent "$@"