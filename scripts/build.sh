#!/bin/bash

set -euo pipefail

## Builds the all the images defined by list.sh

# Combines a dockerfile template with a generated FROM line
dockerfile_from() {
  local dockerfile="$1"
  local from="$2"
  printf 'FROM %s\n%s' "$from" "$(<$dockerfile)"
}

gsort() {
  if [[ "$OSTYPE" =~ ^darwin ]] ; then
    /usr/local/bin/gsort $@
  else
    sort $@
  fi
}

# Returns whether a version number (x.x.x) is greater than another
version_gt() {
  test "$(echo "$@" | tr " " "\n" | gsort -V | tail -n 1)" == "$1"
}

# Returns the highest version of docker-compose supported by a given version of docker
docker_compose_version_from_docker() {
  local docker_version="$1"
  if version_gt $docker_version "1.9.1" ; then
    echo "1.7.0"
  elif version_gt $docker_version "1.7.1" ; then
    echo "1.5.2"
  elif version_gt $docker_version "1.7.0" ; then
    echo "1.5.1"
  else
    echo "1.3.3"
  fi
}

cd $(dirname $0)/../

PATTERN=${1:-.+}

# read the images to build from list.sh
scripts/list.sh | while read line ; do
  tokens=($line)
  tag=${tokens[0]}
  base=${tokens[1]}
  distro=${tokens[2]}
  version=${tokens[3]}
  docker=${tokens[4]:-'n/a'}
  extratags=${tokens[@]:5}

  if [[ ! $tag =~ $PATTERN ]] ; then
    echo "Ignoring $tag due to pattern of $PATTERN"
    continue
  fi

  echo -e "\n--- Building $tag"
  echo "Tag: $tag Base: $base Distro: $distro Version: $version Docker: $docker Aliases: $extratags"

  ## build base images (without docker)
  if [[ $docker == 'n/a' ]] ; then
    docker build \
      --build-arg BUILDKITE_AGENT_VERSION=$version --tag "buildkite/agent:$tag" \
      -f $distro/Dockerfile .

  ## build alpine image (with docker)
  elif [[ $distro == 'alpine' ]] ; then
    docker build \
      --build-arg BUILDKITE_AGENT_VERSION=$version --tag "buildkite/agent:$tag" \
      --build-arg DOCKER_VERSION=$docker \
      --build-arg DOCKER_COMPOSE_VERSION=$(docker_compose_version_from_docker $docker) \
      -f $distro/Dockerfile .

  # build variants with docker from Dockerfile.docker-template
  else
    dockerfile_from "$distro/Dockerfile.docker-template" "buildkite/agent:$base" > dockerfile.tmp
    docker build \
      --build-arg DOCKER_VERSION=$docker \
      --build-arg DOCKER_COMPOSE_VERSION=$(docker_compose_version_from_docker $docker) \
      --tag "buildkite/agent:$tag" \
      -f dockerfile.tmp .
    rm dockerfile.tmp
  fi

  # add extra tags
  for tagalias in ${extratags[@]} ; do
    echo "Tagging buildkite/agent:$tag as buildkite/agent:$tagalias"
    docker tag "buildkite/agent:$tag" "buildkite/agent:$tagalias"
  done
done

echo -e "\033[33;32m--- All images built!\033[0m"