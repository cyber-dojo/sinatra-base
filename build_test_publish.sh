#!/usr/bin/env bash
set -Eeu

export REPO_ROOT="$(git rev-parse --show-toplevel)"
export SH_DIR="${REPO_ROOT}/sh"
source "${SH_DIR}/kosli.sh"
source "${SH_DIR}/lib.sh"

build_docker_image
on_ci_publish_tagged_image
on_ci_kosli_declare_pipeline
on_ci_kosli_report_artifact
#on_ci_kosli_report_synk_evidence
