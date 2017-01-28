#!/bin/bash
set -euo pipefail

tags=(beta edge stable)

for tag in ${tags[*]} ; do
  echo "--- :docker: Building buildkite-agent:${tag}"
  docker build --tag "buildkite-agent:${tag}" -f "${tag}/Dockerfile" .

  echo "--- :hammer: Testing buildkite-agent:${tag} can run"
  docker run --rm --entrypoint "buildkite-agent" "buildkite-agent:${tag}" --version

  echo "--- :hammer: Testing buildkite-agent:${tag} can access docker socket"
  docker run --rm -v /var/run/docker.sock:/var/run/docker.sock --entrypoint "docker" "buildkite-agent:${tag}" test
done
