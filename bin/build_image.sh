#!/usr/bin/env bash
set -Eeu

export REPO_ROOT="$(git rev-parse --show-toplevel)"
source "${REPO_ROOT}/bin/lib.sh"

build_image
# After building, so this build is protected by its own tag, and removing an
# earlier build's tags takes its last tag with them and the image itself goes.
remove_old_images
