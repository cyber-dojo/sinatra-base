ARG BASE_IMAGE=ruby:3.3.5-alpine3.20
FROM ${BASE_IMAGE}
LABEL maintainer=jon@jaggersoft.com

# Update curl for https://scout.docker.com/vulnerabilities/id/CVE-2023-38039
# Update procps for https://scout.docker.com/vulnerabilities/id/CVE-2023-4016
# Install util-linux to use `script` to allow ECS exec logging
# tar is needed to tar-pipe test coverage out of /tmp tmpfs
RUN apk --update --upgrade --no-cache add \
    bash \
    tini \
    procps \
    curl \
    util-linux \
    tar

RUN apk upgrade

WORKDIR /app
COPY Gemfile .

RUN apk add --update --upgrade --virtual build-dependencies build-base \
  && bundle config --global silence_root_warning 1 \
  && bundle install \
  && gem clean \
  && apk del build-dependencies build-base \
     rm -vrf /usr/lib/ruby/gems/*/cache/* \
             /var/cache/apk/* \
             /tmp/* \
             /var/tmp/*

ARG COMMIT_SHA
ENV SHA=${COMMIT_SHA}

# ARGs are reset after FROM See https://github.com/moby/moby/issues/34129
ARG BASE_IMAGE
ENV BASE_IMAGE=${BASE_IMAGE}


