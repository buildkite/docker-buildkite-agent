#!/bin/bash

# Builds and tests all the images

set -eu

for docker_file in $(find . -name Dockerfile -type f); do
  ./scripts/test_image.sh "$(dirname "$docker_file")"
done

echo -e "\033[33;32mAll images look good!\033[0m"
