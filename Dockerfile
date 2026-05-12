FROM ruby:4.0.4-alpine3.23@sha256:ac9c68cd41d6a49a9138fca74aa344968e8ddb5e20d8a3b1f455b97c7148f8da
LABEL maintainer=jon@jaggersoft.com

# Install util-linux to use `script` to allow ECS exec logging
# Install tar to tar-pipe test coverage out of /tmp tmpfs
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
  && bundle config set force_ruby_platform true \
  && bundle install \
  && gem clean \
  && apk del build-dependencies build-base \
     rm -vrf /usr/lib/ruby/gems/*/cache/* \
             /var/cache/apk/* \
             /tmp/* \
             /var/tmp/*

ARG COMMIT_SHA
ENV SHA=${COMMIT_SHA}
