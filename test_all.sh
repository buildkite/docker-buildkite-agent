#!/bin/bash

# Builds and tests all the images

set -eu

for test_file in $(find . -name test.sh -type f); do
  pushd $(dirname "$test_file") > /dev/null

  ./test.sh

  popd > /dev/null
done

echo -e "\033[33;32mAll images looks good!\033[0m"
