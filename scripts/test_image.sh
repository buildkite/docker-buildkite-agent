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

query_bk_agent_api() {
  curl --silent -f -H "Authorization: Bearer $BUILDKITE_DOCKER_INTEGRATION_TEST_API_TOKEN" \
    "https://api.buildkite.com/v1/organizations/$BUILDKITE_DOCKER_INTEGRATION_TEST_ORG_SLUG/agents$@"
}

DOCKER_IMAGE_NAME="$1"
BUILD_ID="${DOCKER_IMAGE_NAME}-${BUILDKITE_BUILD_ID:-dev$$}"

echo "--- :hammer: Testing ${DOCKER_IMAGE_NAME}"

echo ">>> Buildkite version: "
docker run --rm --entrypoint "buildkite-agent" "${DOCKER_IMAGE_NAME}" --version
echo -e "\033[33;32mOk\033[0m"

if [[ -n $(docker_label $DOCKER_IMAGE_NAME "com.buildkite.docker_version") ]] ; then
  echo -e "\n>> Checking docker client for ${DOCKER_IMAGE_NAME}"
  docker run --rm --entrypoint "docker" "${DOCKER_IMAGE_NAME}" --version
  echo -e "\033[33;32mOk\033[0m"
else
  echo -e "\n>> Skipping docker checks"
fi

if [[ -n $(docker_label $DOCKER_IMAGE_NAME "com.buildkite.docker_compose_version") ]] ; then
  echo -e "\n>> Checking docker-compose client for ${DOCKER_IMAGE_NAME}"
  docker run --rm --entrypoint "docker-compose" "${DOCKER_IMAGE_NAME}" --version
  echo -e "\033[33;32mOk\033[0m"
else
  echo -e "\n>>Skipping docker-compose checks"
fi

if [[ $(docker_label $DOCKER_IMAGE_NAME "com.buildkite.docker_dind") == "true" ]] ; then
  echo -e "\n>> Checking docker-in-docker for ${DOCKER_IMAGE_NAME}"
  docker run --rm -e DIND=true --privileged --entrypoint "entrypoint.sh" "${DOCKER_IMAGE_NAME}" docker info
  echo -e "\033[33;32mOk\033[0m"
else
  echo -e "\n>> Skipping docker-in-docker checks"
fi

echo -e ">> Checking buildkite agent phones home"
cidfile="${DOCKER_IMAGE_NAME#*:}.cid"
trap "docker rm -fv \$(cat $cidfile) >/dev/null; rm $cidfile" EXIT

docker run -d --cidfile $cidfile ${DOCKER_IMAGE_NAME} \
  start --name "$BUILD_ID" --token "$BUILDKITE_DOCKER_INTEGRATION_TEST_AGENT_TOKEN" >/dev/null

for run in {1..10} ; do
  sleep 1
  if query_bk_agent_api "?name=$BUILD_ID" > /dev/null ; then
    break
  fi
done

docker stop $(cat $cidfile)

if ! query_bk_agent_api "?name=$BUILD_ID" | grep -C 20 --color=always '"connection_state": "connected"' ; then
  echo "Agent didn't connect to buildkite, showing container logs"
  docker logs $(cat $cidfile)
  exit 1
fi

echo -e "\033[33;32mLooks good!\033[0m"
