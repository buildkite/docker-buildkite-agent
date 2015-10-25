#!/bin/bash

# Builds and tests the given buildkite-agent image
#
# Usage:
#   test_image.sh ubuntu
#   test_image.sh dind/1.8.3
#
# The docker image name can be customized by setting the DOCKER_IMAGE env var.
# For example you might want to set DOCKER_IMAGE="$CI_JOB_ID". The default is
# "buildkite-agent-test".

set -eu

DOCKER_DIR="$1"
DOCKER_FILE="${DOCKER_DIR}/Dockerfile"

if [ ! -f "${DOCKER_FILE}" ]; then
  echo "${DOCKER_FILE} not found" >&2
  exit 1
fi

[ -z "${DOCKER_IMAGE:-}" ] && DOCKER_IMAGE="buildkite-agent-test"
[ -z "${NO_CACHE:-}" ] && NO_CACHE="false"

DOCKER_IMAGE_NAME="${DOCKER_IMAGE}:$(./scripts/helpers/extract_tag.sh "${DOCKER_FILE}")"

# Build

echo "--- :package: Building ${DOCKER_IMAGE_NAME}"

docker build --no-cache="${NO_CACHE}" --tag "${DOCKER_IMAGE_NAME}" "${DOCKER_DIR}"

trap "docker rmi -f \"${DOCKER_IMAGE_NAME}\"" EXIT

# Test

echo "--- :hammer: Testing ${DOCKER_IMAGE_NAME}"

PRIVILEGED=$(./scripts/helpers/extract_privileged.sh "${DOCKER_FILE}")

docker run -it --rm=true --privileged="${PRIVILEGED}" "${DOCKER_IMAGE_NAME}" --version

echo -e "\033[33;32mLooks good!\033[0m"
