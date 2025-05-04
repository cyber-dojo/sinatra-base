
# - - - - - - - - - - - - - - - - - - - - - -
build_docker_image()
{
  local -r dil=$(docker image ls --format "{{.Repository}}:{{.Tag}}")
  remove_all_but_latest "${dil}" "$(image_name)"
  build_image
  tag_image_to_latest # for cache till next build_tagged_images()
  check_embedded_env_var
}

# - - - - - - - - - - - - - - - - - - - - - -
remove_all_but_latest()
{
  local -r docker_image_ls="${1}"
  local -r name="${2}"
  for image_name in `echo "${docker_image_ls}" | grep "${name}:"`
  do
    if [ "${image_name}" != "${name}:latest" ]; then
      if [ "${image_name}" != "${name}:<none>" ]; then
        docker image rm "${image_name}"
      fi
    fi
  done
  docker system prune --force
}

# - - - - - - - - - - - - - - - - - - - - - -
build_image()
{
  docker build \
    --build-arg COMMIT_SHA=$(git_commit_sha) \
    --tag $(image_name):$(image_tag) \
    "${REPO_ROOT}"
}

#- - - - - - - - - - - - - - - - - - - - - - - -
tag_image_to_latest()
{
  docker tag $(image_name):$(image_tag) $(image_name):latest
}

# - - - - - - - - - - - - - - - - - - - - - -
git_commit_sha()
{
  git rev-parse HEAD
}

# - - - - - - - - - - - - - - - - - - - - - -
image_name()
{
  echo cyberdojo/sinatra-base
}

# - - - - - - - - - - - - - - - - - - - - - -
image_sha()
{
  git_commit_sha
}

# - - - - - - - - - - - - - - - - - - - - - -
image_tag()
{
  local -r sha="$(image_sha)"
  echo "${sha:0:7}"
}

# - - - - - - - - - - - - - - - - - - - - - -
check_embedded_env_var()
{
  if [ "$(git_commit_sha)" != "$(sha_in_image)" ]; then
    echo "ERROR: unexpected env-var inside image $(image_name):$(image_tag)"
    echo "expected: 'SHA=$(git_commit_sha)'"
    echo "  actual: 'SHA=$(sha_in_image)'"
    exit 42
  fi
}

# - - - - - - - - - - - - - - - - - - - - - -
sha_in_image()
{
  docker run --rm $(image_name):$(image_tag) sh -c 'echo -n ${SHA}'
}


# - - - - - - - - - - - - - - - - - - - - - - - -
on_ci_publish_tagged_image()
{
  echo
  if ! on_ci; then
    echo 'not on CI so not publishing tagged image'
    echo "$(image_name):$(image_tag)"
  else
    echo 'on CI so publishing tagged image'
    echo "${DOCKER_PASS}" | docker login --username "${DOCKER_USER}" --password-stdin
    docker push $(image_name):latest
    docker push $(image_name):$(image_tag)
    docker logout
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - -
on_ci()
{
  [ "${CI:-}" == true ]
}
