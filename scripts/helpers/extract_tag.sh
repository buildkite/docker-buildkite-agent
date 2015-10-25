#!/bin/bash

# Extracts the tag from our special comment at the top of the Dockerfile
#
# For example, if a Dockerfile has "BK-TAG: hello" then this will echo "hello"
#
# Usage:
#   $ ./extract_dockerfile_tag.sh ubuntu/Dockerfile
#   ubuntu

set -eu

if [ ! -f "$1" ]; then
  echo "File not found: $1" >&2
  exit 1
fi

# Extract the tag from the BK-TAG comment in the Dockerfile
TAG=$(sed -n -e 's/# BK-TAG: \(.*\)/\1/p' "$1")

if [ -z "${TAG}" ]; then
  echo "Failed to extract the BK-TAG comment from $1"  >&2
  exit 1
fi

echo "${TAG}"
