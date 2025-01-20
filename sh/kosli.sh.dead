#!/usr/bin/env bash
set -Eeu

export KOSLI_FLOW=sinatra-base

# KOSLI_ORG is set in CI
# KOSLI_API_TOKEN is set in CI
# KOSLI_API_TOKEN_STAGING is set in CI
# KOSLI_HOST_STAGING is set in CI
# KOSLI_HOST_PRODUCTION is set in CI
# SNYK_TOKEN is set in CI

# - - - - - - - - - - - - - - - - - - -
kosli_create_flow()
{
  local -r hostname="${1}"
  local -r api_token="${2}"

  kosli create flow "${KOSLI_FLOW}" \
    --description="Sinatra base image" \
    --host="${hostname}" \
    --api-token="${api_token}" \
    --template=artifact,snyk-scan \
    --visibility=public
}

# - - - - - - - - - - - - - - - - - - -
kosli_report_artifact_creation()
{
  local -r hostname="${1}"
  local -r api_token="${2}"

  kosli report artifact "$(artifact_name)" \
    --artifact-type=docker \
    --host="${hostname}" \
    --api-token="${api_token}" \
    --repo-root="${REPO_ROOT}"
}

# - - - - - - - - - - - - - - - - - - -
kosli_report_snyk_evidence()
{
  local -r hostname="${1}"
  local -r api_token="${2}"

  kosli report evidence artifact snyk "$(artifact_name)" \
    --artifact-type=docker \
    --host="${hostname}" \
    --api-token="${api_token}" \
    --name=snyk-scan \
    --scan-results=snyk.json
}

# - - - - - - - - - - - - - - - - - - -
kosli_assert_artifact()
{
  local -r hostname="${1}"
  local -r api_token="${2}"

  kosli assert artifact "$(artifact_name)" \
    --artifact-type=docker \
    --host="${hostname}" \
    --api-token="${api_token}"
}

# - - - - - - - - - - - - - - - - - - -
artifact_name()
{
  echo "$(image_name):$(image_tag)"
}

# - - - - - - - - - - - - - - - - - - -
on_ci_kosli_create_flow()
{
  if on_ci; then
    kosli_create_flow "${KOSLI_HOST_STAGING}"    "${KOSLI_API_TOKEN_STAGING}"
    kosli_create_flow "${KOSLI_HOST_PRODUCTION}" "${KOSLI_API_TOKEN}"
  fi
}

# - - - - - - - - - - - - - - - - - - -
on_ci_kosli_report_artifact()
{
  if on_ci; then
    kosli_report_artifact_creation "${KOSLI_HOST_STAGING}"    "${KOSLI_API_TOKEN_STAGING}"
    kosli_report_artifact_creation "${KOSLI_HOST_PRODUCTION}" "${KOSLI_API_TOKEN}"
  fi
}

# - - - - - - - - - - - - - - - - - - -
on_ci_kosli_report_snyk_evidence()
{
  if on_ci; then
    set +e
    snyk container test "$(artifact_name)" \
      --json-file-output=snyk.json \
      --policy-path=.snyk
    set -e

    kosli_report_snyk_evidence "${KOSLI_HOST_STAGING}"    "${KOSLI_API_TOKEN_STAGING}"
    kosli_report_snyk_evidence "${KOSLI_HOST_PRODUCTION}" "${KOSLI_API_TOKEN}"
  fi
}

# - - - - - - - - - - - - - - - - - - -
on_ci_kosli_assert_artifact()
{
  if on_ci; then
    kosli_assert_artifact "${KOSLI_HOST_STAGING}"    "${KOSLI_API_TOKEN_STAGING}"
    kosli_assert_artifact "${KOSLI_HOST_PRODUCTION}" "${KOSLI_API_TOKEN}"
  fi
}
