
FROM ruby:4.0.4-alpine3.23@sha256:f6f95024b33821a2603ba42fa24618c8184f585d83e8a023d81452dbabc13507
# FROM ruby:3.3.10-alpine3.22@sha256:33c684437f1d651cc9200b9e9554a815f020f5bb63593fadbd49d50acd29f0e3
# 3.3 upgrade to 4.0.4 caused languages-start-points service and exercises-start-points
# to be OOM-killed in aws-prod. Alleviated by increasing their mem_limit to 128mb and 
# mem_reservation to 96mb in both deployment/terraform/variables.tf files.
# 3.4.x introduced a GC regression (bugs.ruby-lang.org/issues/21214) in which VmRSS grows ~37%
# higher than 3.3.x for the same workload because transient-object heaps expand in lockstep
# with long-lived-object heaps. The fix was not backported to 3.4.x and landed in 4.0.0
# but as I say above, with 4.0.4 we we're still hitting the OOM killer.
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
