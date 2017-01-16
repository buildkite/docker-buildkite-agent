#!/bin/bash

set -euo pipefail

## Prints supported image combinations in the following format
## {image_name} {base_image} {distro} {buildkite_version} {docker_version} {extra tags...}

ALPINE_DOCKER_VERSIONS=(
  1.9.1
  1.11.2
  1.12.1
)

LATEST_ALPINE_DOCKER=${ALPINE_DOCKER_VERSIONS[${#ALPINE_DOCKER_VERSIONS[@]} - 1]}

UBUNTU_DOCKER_VERSIONS=(
  1.6.2
  1.7.1
  1.8.3
  1.9.1
  1.10.3
  1.11.2
  1.12.1
)

LATEST_UBUNTU_DOCKER=${UBUNTU_DOCKER_VERSIONS[${#UBUNTU_DOCKER_VERSIONS[@]} - 1]}

DISTROS=(
  alpine
  ubuntu
)

BUILDKITE_VERSIONS=(
  stable
  beta
  edge
)

# Returns the major version for a given X.X.X docker version
docker_major_version() {
  cut -d. -f1-2 <<< $1
}

image_name() {
  local release="$1"
  local distro="$2"
  printf "%s-%s" "$release" "$distro" | sed -e 's/^stable-//g'
}

for version in ${BUILDKITE_VERSIONS[*]} ; do
  distro="alpine"
  docker="n/a"
  for docker_version in ${ALPINE_DOCKER_VERSIONS[*]} ; do
    printf "%s-docker-%s %s %s %s %s %s-docker-%s" \
      $(image_name "$version" "$distro") $docker_version \
      "n/a" \
      $distro $version $docker_version \
      $(image_name "$version" "$distro") $(docker_major_version $docker_version)

    if [[ $docker_version == $LATEST_ALPINE_DOCKER ]] ; then
      # We also want to give the alpine distro the official
      # buildkite/agent:[latest,edge,beta] tags
      printf " %s" $(sed -e 's/stable/latest/g' <<< $version)

      printf " %s" $(image_name "$version" "$distro")

      printf " %s-docker" $(image_name "$version" "$distro")
    fi

    echo #newline
  done
done

for version in ${BUILDKITE_VERSIONS[*]} ; do
  distro="ubuntu"
  docker="n/a"
  printf "%s %s %s %s %s\n" $(image_name "$version" "$distro") "n/a" "$distro" "$version" "$docker"
  for docker_version in ${UBUNTU_DOCKER_VERSIONS[*]} ; do
    printf "%s-docker-%s %s %s %s %s %s-docker-%s" \
      $(image_name "$version" "$distro") $docker_version \
      $(image_name "$version" "$distro") \
      $distro $version $docker_version \
      $(image_name "$version" "$distro") $(docker_major_version $docker_version)

    if [[ $docker_version == $LATEST_UBUNTU_DOCKER ]] ; then
      printf " %s-docker" $(image_name "$version" "$distro")
    fi

    echo #newline
  done
done
