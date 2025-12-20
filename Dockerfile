FROM ruby:3.3.10-alpine3.22@sha256:33c684437f1d651cc9200b9e9554a815f020f5bb63593fadbd49d50acd29f0e3
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

RUN apk upgrade
RUN apk add --upgrade c-ares=1.34.6-r0  # https://security.snyk.io/vuln/SNYK-ALPINE322-CARES-14409293


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



