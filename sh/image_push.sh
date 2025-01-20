#!/usr/bin/env bash
set -Eeu

export REPO_ROOT="$(git rev-parse --show-toplevel)"
source "${REPO_ROOT}/sh/lib.sh"

echo "${DOCKER_PASS}" | docker login --username "${DOCKER_USER}" --password-stdin
docker push $(image_name):latest
docker push $(image_name):$(image_tag)
docker logout
