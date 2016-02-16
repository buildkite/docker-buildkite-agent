#!/bin/bash

set -euo pipefail

## Prints supported image combinations in the following format
## {image_name} {base_image} {distro} {buildkite_version} {docker_version} {extra tags...}

DOCKER_VERSIONS=(
  1.6.2
  1.7.1
  1.8.3
  1.9.1
  1.10.1
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

LATEST_DOCKER=${DOCKER_VERSIONS[${#DOCKER_VERSIONS[@]} - 1]}
ALPINE_DOCKER=1.9.1

# Returns the major version for a given X.X.X docker version
docker_major_version() {
  cut -d. -f1-2 <<< $1
}

image_name() {
  local release="$1"
  local distro="$2"
  printf "%s-%s" "$release" "$distro" | sed -e 's/^stable-//g'
}

for distro in ${DISTROS[*]} ; do
  for version in ${BUILDKITE_VERSIONS[*]} ; do
    tags=()
    if [[ $distro == "alpine" ]] ; then
      tags+=($(sed -e 's/stable/latest/g' <<< $version))
      tags+=($(printf "%s-docker-%s" $(image_name "$version" "$distro") $(docker_major_version "$ALPINE_DOCKER")))
    fi
    printf "%s %s %s %s n/a ${tags[*]-}\n" $(image_name "$version" "$distro") "n/a" "$distro" "$version"
    if [[ ! -f "$distro/Dockerfile.docker-template" ]] ; then
     continue
    fi
    for docker_version in ${DOCKER_VERSIONS[*]} ; do
      printf "%s-docker-%s %s %s %s %s %s-docker-%s" \
        $(image_name "$version" "$distro") $docker_version \
        $(image_name "$version" "$distro") \
        $distro $version $docker_version \
        $(image_name "$version" "$distro") $(docker_major_version $docker_version)

      if [[ $docker_version == $LATEST_DOCKER ]] ; then
        printf " %s-docker" $(image_name "$version" "$distro")
      fi

      echo #newline
    done
  done
done