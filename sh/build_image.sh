#!/usr/bin/env bash
set -Eeu

build_image()
{
  local -r repo_root="$(git rev-parse --show-toplevel)"
  local -r commit_sha="$(git rev-parse HEAD)"
  local -r image_tag="${commit_sha:0:7}"
  docker build \
    --build-arg "COMMIT_SHA=${commit_sha}" \
    --tag "cyberdojo/sinatra-base:${image_tag}" \
    "${repo_root}"
}

build_image
