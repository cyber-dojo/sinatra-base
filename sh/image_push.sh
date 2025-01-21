#!/usr/bin/env bash
set -Eeu

echo "${DOCKER_PASS}" | docker login --username "${DOCKER_USER}" --password-stdin
docker push "${IMAGE_NAME}"
docker logout
