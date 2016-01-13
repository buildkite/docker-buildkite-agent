#!/bin/bash

set -euo pipefail

scripts/list.sh | while read line ; do
  tokens=($line)
  image=${tokens[0]}
  ./scripts/test_image.sh "buildkite/$image"
done

echo -e "\033[33;32mAll images look good!\033[0m"
