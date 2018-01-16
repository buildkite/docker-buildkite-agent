#!/bin/bash
set -euo pipefail

: ${DOCKER_IMAGE:=buildkite/agent}

tags=(beta edge stable)

for tag in ${tags[*]} ; do
  echo "--- :docker: Building ${DOCKER_IMAGE}:${tag}"
  docker build --tag "${DOCKER_IMAGE}:${tag}" -f "${tag}/Dockerfile" .

  echo "--- :hammer: Testing ${DOCKER_IMAGE}:${tag} can run"
  docker run --rm --entrypoint "buildkite-agent" "${DOCKER_IMAGE}:${tag}" --version

  echo "--- :hammer: Testing ${DOCKER_IMAGE}:${tag} can access docker socket"
  docker run --rm -v /var/run/docker.sock:/var/run/docker.sock --entrypoint "docker" "${DOCKER_IMAGE}:${tag}" version

  echo "--- :hammer: Testing ${DOCKER_IMAGE}:${tag} can run docker hello world"
  docker run --rm -v /var/run/docker.sock:/var/run/docker.sock --entrypoint "docker" "${DOCKER_IMAGE}:${tag}" run --rm hello-world

  echo "--- :hammer: Testing ${DOCKER_IMAGE}:${tag} has docker-compose"
  docker run --rm --entrypoint "docker-compose" "${DOCKER_IMAGE}:${tag}" --version
done
