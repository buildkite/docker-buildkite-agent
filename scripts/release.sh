#!/bin/bash

set -euo pipefail

scripts/list.sh | while read line ; do
  tokens=($line)
  image=${tokens[0]}
  echo "--- Pushing buildkite/$image"
  echo docker push "buildkite/$image"
done

echo -e "\033[33;32m--- All images released!\033[0m"