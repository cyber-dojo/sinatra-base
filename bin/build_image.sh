#!/usr/bin/env bash
set -Eeu

export REPO_ROOT="$(git rev-parse --show-toplevel)"
source "${REPO_ROOT}/bin/lib.sh"

build_image
tag_image_to_latest
# After tagging, so removing an earlier build's tags takes its last tag with
# them and the image itself goes, rather than being left dangling when :latest
# moves to this build.
remove_old_images
