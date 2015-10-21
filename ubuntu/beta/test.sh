#!/bin/bash

set -eu

tag="buildkite-agent-test:ubuntu-beta"

docker build --tag "$tag" .
docker run -it --rm=true "$tag" --version

echo -e "\033[33;32mLooks good!\033[0m"
