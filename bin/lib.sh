
# - - - - - - - - - - - - - - - - - - - - - -
# Builds the amd64 and arm64 variants under one tag. --load puts the resulting
# multi-platform manifest into the local image store, which relies on Docker's
# containerd image store; the classic store holds only one platform per tag.
build_image()
{
  docker buildx build \
    --platform linux/amd64,linux/arm64 \
    --load \
    --build-arg COMMIT_SHA=$(git_commit_sha) \
    --tag $(image_name):$(image_tag) \
    "${REPO_ROOT}"
}

# - - - - - - - - - - - - - - - - - - - - - -
git_commit_sha()
{
  git rev-parse HEAD
}

# - - - - - - - - - - - - - - - - - - - - - -
image_name()
{
  echo ghcr.io/cyber-dojo/sinatra-base
}

# - - - - - - - - - - - - - - - - - - - - - -
image_tag()
{
  local -r sha="$(image_sha)"
  echo "${sha:0:7}"
}

# - - - - - - - - - - - - - - - - - - - - - -
image_sha()
{
  git_commit_sha
}


# - - - - - - - - - - - - - - - - - - - - - -
# Keeps this commit's tag, which names the build just made. Every older tag
# goes, and an earlier build whose last tag was one of those goes with it, so
# local builds stop accumulating images.
remove_old_images()
{
  local -r name="$(image_name)"
  local -r tag="$(image_tag)"
  echo Removing old images
  # grep exits non-zero when the machine holds no sinatra-base image, eg one
  # whose images have just been cleared, so an empty list must not end the build.
  local tagged_name
  for tagged_name in $(docker image ls --format '{{.Repository}}:{{.Tag}}' | grep "^${name}:" || true)
  do
    if [ "${tagged_name}" != "${name}:${tag}" ]; then
      # Removing by name:tag untags, so this succeeds even while a container
      # references the image, leaving it dangling until that container goes.
      docker image rm --force "${tagged_name}" || echo "  skipped ${tagged_name} (in use)"
    fi
  done
}
