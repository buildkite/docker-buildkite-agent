#!/bin/bash

set -euo pipefail

## Prints supported image combinations in the following format
## {image_name} {base_image} {distro} {buildkite_version} {docker_version}

DOCKER_VERSIONS=(
  1.6.2
  1.7.1
  1.8.3
  1.9.0
)

DISTROS=(
  alpine
  ubuntu
)

BUILDKITE_VERSIONS=(
  stable
  beta
  edge
)

image_name() {
  local release="$1"
  local distro="$2"
  printf "%s-%s" "$release" "$distro" | sed -e 's/^stable-//g'
}

for distro in ${DISTROS[*]} ; do
  for version in ${BUILDKITE_VERSIONS[*]} ; do
    printf "%s %s %s %s\n" $(image_name "$version" "$distro") "n/a" "$distro" "$version"
    if [[ ! -f "$distro/Dockerfile.docker-template" ]] ; then
     continue
    fi
    for docker_version in ${DOCKER_VERSIONS[*]} ; do
      printf "%s-docker-%s %s %s %s %s %s\n" \
        $(image_name "$version" "$distro") $docker_version \
        $(image_name "$version" "$distro") \
        $distro $version $docker_version
    done
  done
done