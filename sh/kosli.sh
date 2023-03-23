
# KOSLI_ORG is set in CI
# KOSLI_API_TOKEN is set in CI
# KOSLI_FLOW is set in CI
# KOSLI_HOST_STAGING is set in CI
# KOSLI_HOST_PRODUCTION is set in CI

# - - - - - - - - - - - - - - - - - - -
kosli_create_flow()
{
  local -r hostname="${1}"

  kosli create flow "${KOSLI_FLOW}" \
    --description "Sinatra base image" \
    --host "${hostname}" \
    --template artifact,snyk-scan \
    --visibility public
}

# - - - - - - - - - - - - - - - - - - -
kosli_report_artifact_creation()
{
  local -r hostname="${1}"

  kosli report artifact "$(artifact_name)" \
      --artifact-type docker \
      --host "${hostname}" \
      --repo-root "${REPO_ROOT}"
}

# - - - - - - - - - - - - - - - - - - -
kosli_report_snyk_evidence()
{
  local -r hostname="${1}"

  kosli report evidence artifact snyk "$(artifact_name)" \
      --artifact-type docker \
      --host "${hostname}" \
      --name snyk-scan \
      --scan-results snyk.json
}

# - - - - - - - - - - - - - - - - - - -
kosli_assert_artifact()
{
  local -r hostname="${1}"

  kosli assert artifact "$(artifact_name)" \
      --artifact-type docker \
      --host "${hostname}"
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
    kosli_create_flow "${KOSLI_HOST_STAGING}"
    kosli_create_flow "${KOSLI_HOST_PRODUCTION}"
  fi
}

# - - - - - - - - - - - - - - - - - - -
on_ci_kosli_report_artifact()
{
  if on_ci; then
    kosli_report_artifact_creation "${KOSLI_HOST_STAGING}"
    kosli_report_artifact_creation "${KOSLI_HOST_PRODUCTION}"
  fi
}

# - - - - - - - - - - - - - - - - - - -
on_ci_kosli_report_snyk_evidence()
{
  if on_ci; then
    snyk container test "$(artifact_name)" \
      --file="${REPO_ROOT}/app/Dockerfile" \
      --json-file-output=snyk.json \
      --policy-path=.snyk

    kosli_report_snyk_evidence "${KOSLI_HOST_STAGING}"
    kosli_report_snyk_evidence "${KOSLI_HOST_PRODUCTION}"
  fi
}

# - - - - - - - - - - - - - - - - - - -
on_ci_kosli_assert_artifact()
{
  if on_ci; then
    kosli_assert_artifact "${KOSLI_HOST_STAGING}"
    kosli_assert_artifact "${KOSLI_HOST_PRODUCTION}"
  fi
}



