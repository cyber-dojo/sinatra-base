FROM ruby:3.3.7-alpine3.20@sha256:e1996c64c354f55460390a45df2033a5c246db9f1c7af31840909a0d2b7b2e7c
LABEL maintainer=jon@jaggersoft.com

# Install util-linux to use `script` to allow ECS exec logging
# tar is needed to tar-pipe test coverage out of /tmp tmpfs
RUN apk --update --upgrade --no-cache add \
    bash \
    tini \
    procps \
    curl \
    util-linux \
    tar

RUN apk add --upgrade git=2.45.4-r0 # https://security.snyk.io/vuln/SNYK-ALPINE320-GIT-10669667
RUN apk upgrade

WORKDIR /app
COPY Gemfile .

RUN apk add --update --upgrade --virtual build-dependencies build-base \
  && bundle config --global silence_root_warning 1 \
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



