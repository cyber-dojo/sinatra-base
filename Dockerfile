
FROM ruby:3.3.10-alpine3.22@sha256:33c684437f1d651cc9200b9e9554a815f020f5bb63593fadbd49d50acd29f0e3
# FROM ruby:4.0.4-alpine3.23@sha256:ac9c68cd41d6a49a9138fca74aa344968e8ddb5e20d8a3b1f455b97c7148f8da
# Pinned to 3.3 because upgrading to 4.0.4 caused languages-start-points service to be
# OOM-killed in aws-prod.
# 3.4.x introduced a GC regression (bugs.ruby-lang.org/issues/21214) in which VmRSS grows ~37%
# higher than 3.3.x for the same workload because transient-object heaps expand in lockstep
# with long-lived-object heaps. The fix was not backported to 3.4.x and landed in 4.0.0
# but as I say above, with 4.0.4 we're hitting the OOM killer.
# Do not move past 3.3.x until this is fixed.
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
  && rm -vrf /usr/lib/ruby/gems/*/cache/* \
             /usr/local/bundle/cache/* \
             /var/cache/apk/* \
             /tmp/* \
             /var/tmp/*

ARG COMMIT_SHA
ENV SHA=${COMMIT_SHA}
