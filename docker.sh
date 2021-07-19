#!/bin/bash

set -ex

if [[ -f /.dockerenv ]]; then
  exit 1
fi

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly DOCKER_FILE=${DOCKER_FILE:-"${SCRIPT_DIR}/docker/Dockerfile"}
readonly DOCKER_IMAGE=${DOCKER_IMAGE:-debian:buster}
readonly DOCKER_IMAGE_TAG=$(docker build --build-arg IMAGE="${DOCKER_IMAGE}" --quiet - < "${DOCKER_FILE}")
docker run -it --rm -v $(pwd):/workspace -w /workspace "${DOCKER_IMAGE_TAG}" /bin/bash
