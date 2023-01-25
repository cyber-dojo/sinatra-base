
# KOSLI_OWNER is set in CI
# KOSLI_API_TOKEN is set in CI
# KOSLI_PIPELINE is set in CI
# KOSLI_HOST_STAGING is set in CI
# KOSLI_HOST_PRODUCTION is set in CI

# - - - - - - - - - - - - - - - - - - -
kosli_declare_pipeline()
{
  local -r hostname="${1}"

  kosli pipeline declare \
    --description "Sinatra base image" \
    --visibility public \
    --template artifact,snyk-scan \
    --host "${hostname}"
}

# - - - - - - - - - - - - - - - - - - -
kosli_report_artifact_creation()
{
  local -r hostname="${1}"

  kosli pipeline artifact report creation \
    "$(artifact_name)" \
      --artifact-type docker \
      --repo-root "${REPO_ROOT}" \
      --host "${hostname}"
}

# - - - - - - - - - - - - - - - - - - -
kosli_report_snyk_evidence()
{
  local -r hostname="${1}"

  kosli pipeline artifact report evidence snyk \
    "$(artifact_name)" \
      --artifact-type docker \
      --name snyk-scan \
      --scan-results snyk.json \
      --host "${hostname}"
}

# - - - - - - - - - - - - - - - - - - -
kosli_assert_artifact()
{
  local -r hostname="${1}"

  kosli assert artifact \
    "$(artifact_name)" \
      --artifact-type docker \
      --host "${hostname}"
}

# - - - - - - - - - - - - - - - - - - -
artifact_name()
{
  echo "$(image_name):$(image_tag)"
}

# - - - - - - - - - - - - - - - - - - -
on_ci_kosli_declare_pipeline()
{
  if on_ci
  then
    kosli_declare_pipeline "${KOSLI_HOST_STAGING}"
    kosli_declare_pipeline "${KOSLI_HOST_PRODUCTION}"
  fi
}

# - - - - - - - - - - - - - - - - - - -
on_ci_kosli_report_artifact()
{
  if on_ci
  then
    kosli_report_artifact_creation "${KOSLI_HOST_STAGING}"
    kosli_report_artifact_creation "${KOSLI_HOST_PRODUCTION}"
  fi
}

# - - - - - - - - - - - - - - - - - - -
on_ci_kosli_report_snyk_evidence()
{
  if on_ci
  then
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
  if on_ci
  then
    kosli_assert_artifact "${KOSLI_HOST_STAGING}"
    kosli_assert_artifact "${KOSLI_HOST_PRODUCTION}"
  fi
}



