#!/bin/bash

set -euo pipefail

## Builds and tests the given buildkite-agent image
##
## Usage:
##   test_image.sh buildkite/ubuntu
##   test_image.sh buildkite/beta-ubuntu-docker-1.8.3

docker_label() {
  local image="$1"
  local label="$2"
  docker inspect --format "{{ index .Config.Labels \"$label\" }}" "$image"
}

DOCKER_IMAGE_NAME="$1"

echo "--- :hammer: Testing ${DOCKER_IMAGE_NAME}"

docker images "${DOCKER_IMAGE_NAME}"
docker run --rm "${DOCKER_IMAGE_NAME}" --version

if [[ -n $(docker_label $DOCKER_IMAGE_NAME "com.buildkite.docker_version") ]] ; then
  echo "--- :hammer: Checking docker client for ${DOCKER_IMAGE_NAME}"
  docker run --rm --entrypoint "docker" "${DOCKER_IMAGE_NAME}" --version
fi

if [[ -n $(docker_label $DOCKER_IMAGE_NAME "com.buildkite.docker_compose_version") ]] ; then
  echo "--- :hammer: Checking docker-compose client for ${DOCKER_IMAGE_NAME}"
  docker run --rm --entrypoint "docker-compose" "${DOCKER_IMAGE_NAME}" --version
fi

if [[ $(docker_label $DOCKER_IMAGE_NAME "com.buildkite.docker_dind") == "true" ]] ; then
  echo "--- :hammer: Checking docker-in-docker for ${DOCKER_IMAGE_NAME}"
  docker run --rm -e DIND=true --privileged --entrypoint "entrypoint.sh" "${DOCKER_IMAGE_NAME}" docker info
fi

echo -e "\033[33;32mLooks good!\033[0m"
