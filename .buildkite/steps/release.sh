#!/bin/bash
set -euo pipefail

tags=(beta edge stable)

for tag in ${tags[*]} ; do
  echo "--- :docker: Building buildkite-agent:${tag}"
  docker build --tag "buildkite-agent:${tag}" -f "${tag}/Dockerfile" .
done

docker push buildkite-agent:stable
docker push buildkite-agent:beta
docker push buildkite-agent:edge

# variants of stable - 2.3.2
for tag in latest 2.3.2 2.3 2 ; do
  docker tag buildkite-agent:stable "buildkite-agent:$tag"
  docker push "buildkite-agent:$tag"
done

# variants of beta 3.0-beta.9
for tag in 3.0-beta.9 3.0 3 ; do
  docker tag buildkite-agent:beta "buildkite-agent:$tag"
  docker push "buildkite-agent:$tag"
done