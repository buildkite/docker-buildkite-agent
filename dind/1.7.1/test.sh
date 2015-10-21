#!/bin/bash

set -eu

tag="buildkite-agent-test:dind-1.7.1"

docker build --tag "$tag" .
docker run -it --rm=true --privileged=true "$tag" --version

echo -e "\033[33;32mLooks good!\033[0m"
