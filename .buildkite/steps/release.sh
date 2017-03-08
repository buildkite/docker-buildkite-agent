#!/bin/bash
set -euo pipefail

: ${DOCKER_IMAGE:=buildkite/agent}
: ${DOCKER_PUSH:=1}

# parse a docker version like "buildkite-agent version 2.3.2, build 1408"
# return a series of numbers like [ 2.3.2 2.3 2 ]
function parse_version {
  v=$(echo "$1" | awk '{print $3}' | sed -e 's/,//')
  IFS='.' read -r -a parts <<< "${v%-*}"

  for idx in $(seq 1 ${#parts[*]}) ; do
    sed -e 's/ /./g' <<< "${parts[@]:0:$idx}"
  done

  [[ "${v%-*}" == "$v" ]] || echo "$v"
}

tags=(beta edge stable)

for tag in ${tags[*]} ; do
  echo "--- :docker: Building ${DOCKER_IMAGE}:${tag}"
  docker build --tag "${DOCKER_IMAGE}:${tag}" -f "${tag}/Dockerfile" .
done

if [[ "$DOCKER_PUSH" =~ (true|1) ]]; then
  docker push "${DOCKER_IMAGE}:stable"
  docker push "${DOCKER_IMAGE}:beta"
  docker push "${DOCKER_IMAGE}:edge"
fi

# variants of stable - e.g 2.3.2
for tag in latest $(parse_version "$(docker run "${DOCKER_IMAGE}:stable" --version)") ; do
  echo "--- :docker: Tagging ${DOCKER_IMAGE}:${tag} (stable)"
  docker tag "${DOCKER_IMAGE}:stable" "${DOCKER_IMAGE}:$tag"
  [[ "$DOCKER_PUSH" =~ (true|1) ]] && docker push "${DOCKER_IMAGE}:$tag"
done

# variants of beta - e.g 3.0-beta.16
for tag in $(parse_version "$(docker run "${DOCKER_IMAGE}:beta" --version)") ; do
  echo "--- :docker: Tagging ${DOCKER_IMAGE}:${tag} (beta)"
  docker tag "${DOCKER_IMAGE}:beta" "${DOCKER_IMAGE}:$tag"
  [[ "$DOCKER_PUSH" =~ (true|1) ]] && docker push "${DOCKER_IMAGE}:$tag"
done