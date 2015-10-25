#!/bin/bash

# Generates a pipeline with a step for each image. This allows you to run
# all the tests in parallel, as opposed to the test_all.sh script which has to
# run in serial. It also means you get GH statuses and jobs for each image.

set -eu

echo "steps:"

for DOCKER_FILE in $(find . -name Dockerfile -type f); do
  TAG=$(./scripts/helpers/extract_tag.sh "${DOCKER_FILE}")

  echo "  - command: \"./scripts/test_image.sh '$(dirname "$DOCKER_FILE")'\""
  echo "    name: \"${TAG}\""
  echo "    agents:"
  echo "      docker: true"
  echo "    env:"
  echo "      DOCKER_IMAGE: buildkite-agent-$BUILDKITE_JOB_ID"
done
