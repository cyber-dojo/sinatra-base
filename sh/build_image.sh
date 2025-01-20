#!/usr/bin/env bash
set -Eeu

export REPO_ROOT="$(git rev-parse --show-toplevel)"
source "${REPO_ROOT}/sh/lib.sh"

build_image
