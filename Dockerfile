ARG BASE_IMAGE=ruby:alpine3.19
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

RUN apk add openssl=3.1.5-r0   # https://security.snyk.io/vuln/SNYK-ALPINE319-OPENSSL-6928853
RUN apk add libexpat=2.6.2-r0  # https://security.snyk.io/vuln/SNYK-ALPINE319-EXPAT-6446355
RUN apk add nodejs=20.12.1-r0  # https://security.snyk.io/vuln/SNYK-ALPINE319-NODEJS-6531253
RUN apk add c-ares=1.27.0-r0   # https://security.snyk.io/vuln/SNYK-ALPINE319-CARES-6483773
RUN apk add busybox=1.36.1-r17 # https://security.snyk.io/vuln/SNYK-ALPINE319-BUSYBOX-6928847
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


