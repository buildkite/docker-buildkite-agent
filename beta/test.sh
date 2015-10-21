#!/bin/bash

set -eu

docker build --tag "buildkite-agent-test:beta" .

docker run -it --rm=true "buildkite-agent-test:beta" --version

echo -e "\033[33;32mLooks good!\033[0m"
