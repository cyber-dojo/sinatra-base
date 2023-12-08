ARG BASE_IMAGE=cyberdojo/rack-base:9b2b2d2
FROM ${BASE_IMAGE}
LABEL maintainer=jon@jaggersoft.com

RUN apk add nodejs
RUN apk add libcurl=8.5.0-r0        # https://security.snyk.io/vuln/SNYK-ALPINE318-CURL-6104720
RUN apk add nghttp2-libs=1.57.0-r0  # https://security.snyk.io/vuln/SNYK-ALPINE318-NGHTTP2-5954768
RUN apk add libcrypto3=3.1.4-r1     # https://security.snyk.io/vuln/SNYK-ALPINE318-OPENSSL-6055795
RUN apk upgrade

WORKDIR /app

COPY Gemfile .

RUN apk add --update --upgrade --virtual \
    build-dependencies \
    build-base \
 && echo "gem: --no-rdoc --no-ri" > ~/.gemrc \
 && bundle install \
 && gem clean \
 && apk del build-dependencies build-base \
    rm -vrf /usr/lib/ruby/gems/*/cache/* \
            /var/cache/apk/* \
            /tmp/* \
            /var/tmp/*

ARG COMMIT_SHA
ENV SHA=${COMMIT_SHA}
ENV COMMIT_SHA=${COMMIT_SHA}

# ARGs are reset after FROM See https://github.com/moby/moby/issues/34129
ARG BASE_IMAGE
ENV BASE_IMAGE=${BASE_IMAGE}


