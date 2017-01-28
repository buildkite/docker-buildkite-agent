#!/bin/bash
set -euo pipefail

tags=(beta edge stable)

for tag in ${tags[*]} ; do
  echo "--- :docker: Building buildkite-agent:${tag}"
  docker build --tag "buildkite-agent:${tag}" -f "${tag}/Dockerfile" .

  echo "--- :hammer: Testing buildkite-agent:${tag} runs"
  docker run --rm --entrypoint "buildkite-agent" "buildkite-agent:${tag}" --version
done
