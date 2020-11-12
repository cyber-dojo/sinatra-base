#!/bin/bash -Eeu

readonly SH_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/sh" && pwd)"
source "${SH_DIR}/build_docker_image.sh"
#source "${SH_DIR}/on_ci_publish_tagged_images.sh"

build_docker_image
#on_ci_publish_tagged_images
