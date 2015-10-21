#!/bin/bash

# Builds and tests all the Dockerfiles in this repo to ensure that everything builds AOK

set -eu

# Returns a list like so:
# ./Dockerfile
# ./beta/Dockerfile
# ./dind/1.6.2/Dockerfile
docker_files=$(find . -name Dockerfile -type f)

for docker_file in $docker_files; do
  # We want:
  # ./Dockerfile            -> buildkite-agent:test
  # ./beta/Dockerfile       -> buildkite-agent:test-beta
  # ./dind/1.6.2/Dockerfile -> buildkite-agent:test-dind-1.6.2

  # Strip off tailing /Dockerfile
  tag="${docker_file//\/Dockerfile}"
  # Strip off leading ./
  tag="${tag//.\/}"
  # Replace all / with -
  tag="${tag//\//-}"

  tag="buildkite-agent-test:$tag"

  # Change into the directory
  pushd $(dirname "$docker_file") > /dev/null

  echo -e "\033[33;36m--- Building $docker_file as $tag\033[0m"
  docker build --tag "$tag" .

  echo -e "\033[33;36m--- Testing $tag\033[0m"
  echo "docker run -it --rm=true --privileged=true \"$tag\" --version"
  docker run -it --rm=true --privileged=true "$tag" --version

  echo -e "\033[33;32mLooks good! \\m/\\m/\033[0m"

  popd > /dev/null
done

echo -e "\033[33;32mAll images looks good!\033[0m"
