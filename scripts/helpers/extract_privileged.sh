#!/bin/bash

# Extracts the privileged flag from our special comment at the top of the Dockerfile
#
# For example, if a Dockerfile has "BK-PRIViLEGED" then this will echo "true". If not, then this will echo "false"
#
# Usage:
#   $ ./extract_dockerfile_privileged.sh ubuntu/Dockerfile
#   false
#   $ ./extract_dockerfile_privileged.sh dind/1.7.1/Dockerfile
#   true

set -eu

if [ ! -f "$1" ]; then
  echo "File not found: $1" >&2
  exit 1
fi

if grep --quiet '# BK-PRIVILEGED' "$1"; then
  echo "true"
else
  echo "false"
fi
