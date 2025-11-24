#FROM ruby:3.3.7-alpine3.20@sha256:e1996c64c354f55460390a45df2033a5c246db9f1c7af31840909a0d2b7b2e7c
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
#RUN apk upgrade libcrypto3 libssl3       # https://security.snyk.io/vuln/SNYK-ALPINE322-OPENSSL-13174133
#RUN apk upgrade git                      # https://security.snyk.io/vuln/SNYK-ALPINE320-GIT-10669667
#RUN apk upgrade libexpat                 # https://security.snyk.io/vuln/SNYK-ALPINE320-EXPAT-13003709
#RUN apk upgrade musl                     # https://security.snyk.io/vuln/SNYK-ALPINE320-MUSL-8720638

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



