#!/bin/bash

set -euo pipefail

scripts/list.sh | while read line ; do
  tokens=($line)
  image=${tokens[0]}
  extratags=${tokens[@]:5}

  echo "--- Pushing buildkite/agent:$image"
  docker push "buildkite/agent:$image"

  for aliastag in ${extratags[@]} ; do
    echo "--- Pushing buildkite/agent:$aliastag"
    docker push "buildkite/agent:$aliastag"
  done
done

echo -e "\033[33;32m--- All images released!\033[0m"