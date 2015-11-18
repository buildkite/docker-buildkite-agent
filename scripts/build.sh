#!/bin/bash -euo pipefail

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

DOCKER_COMPOSE_VERSION=1.5.1

image_name() {
  local release="$1"
  local distro="$2"
  printf "%s-%s" "$release" "$distro" | sed -e 's/^stable-//g'
}

docker_major_version() {
  cut -d. -f1-2 <<< $1
}

dockerfile_from() {
  local dockerfile="$1"
  local from="$2"
  printf 'FROM %s\n%s' "$from" "$(<$dockerfile)"
}

version_gt() {
  test "$(echo "$@" | tr " " "\n" | gsort -V | tail -n 1)" == "$1"
}

docker_compose_version_from_docker() {
  local docker_version="$1"
  if version_gt $docker_version "1.7.0" ; then
    echo $DOCKER_COMPOSE_VERSION
  else
    echo "1.3.3"
  fi
}

cd $(dirname $0)/../

# build base releases first
# ----------------------------------

for distro in ${DISTROS[*]} ; do
  for version in ${BUILDKITE_VERSIONS[*]} ; do
    image=$(image_name $version $distro)
    echo -e "\n--- Building buildkite/$image"
    docker build \
      --build-arg BUILDKITE_AGENT_VERSION=$version --tag buildkite/$image \
      -f $distro/Dockerfile .
  done
done

# build and tag docker variants
# ----------------------------------

for distro in ${DISTROS[*]} ; do
  if [[ ! -f "$distro/Dockerfile.docker-template" ]] ; then
    echo "Skipping $distro, no docker-template"
   continue
  fi

  for version in ${BUILDKITE_VERSIONS[*]} ; do
    for docker_version in ${DOCKER_VERSIONS[*]} ; do
      base=$(image_name $version $distro)
      image=$(printf "%s-docker-%s" $base $docker_version)
      tag=$(printf "%s-docker-%s" $base $(docker_major_version $docker_version))

      dockerfile_from "$distro/Dockerfile.docker-template" "buildkite/$base" > dockerfile.tmp
      echo -e "\n--- Building buildkite/$image"
      docker build \
        --build-arg DOCKER_VERSION=$docker_version \
        --build-arg DOCKER_COMPOSE_VERSION=$(docker_compose_version_from_docker $docker_version) \
        --tag buildkite/$image \
        -f dockerfile.tmp .
      rm dockerfile.tmp

      echo -e "\n--- Tagging buildkite/$image as buildkite/$tag"
      docker tag -f buildkite/$image buildkite/$tag
    done
  done
done

# for release in ${RELEASES[*]} ; do
#   for distro in ${DISTROS[*]} ; do
#     base=$(image_name $release $distro)
#     docker_latest_version=""
#     echo "build $base"
#     for docker_version in ${DOCKER_VERSIONS[*]} ; do
#       if is_build_skipped $release $distro $docker_version ; then
#         continue
#       fi
#       docker_build=$(docker_image_name $release $distro $docker_version)
#       echo "build $docker_build $base"
#       echo "tag $(docker_major_image_name $release $distro $docker_version) $docker_build"
#       docker_latest_version=$docker_version
#     done
#     docker_latest=$(docker_image_name $release $distro $docker_latest_version)
#     echo "tag $(image_name $release $distro)-docker"
#   done
# done
# echo "tag alpine-docker-latest master"