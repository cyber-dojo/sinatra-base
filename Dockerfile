FROM ruby:3.3.6-alpine3.20
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

RUN apk add libcrypto3=3.3.2-r1   # https://security.snyk.io/vuln/SNYK-ALPINE320-OPENSSL-8235201
RUN apk add libcurl=8.11.0-r1     # https://security.snyk.io/vuln/SNYK-ALPINE320-CURL-8348469
RUN apk add libexpat=2.6.4-r0     # https://security.snyk.io/vuln/SNYK-ALPINE320-EXPAT-8359601
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



