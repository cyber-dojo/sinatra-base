FROM cyberdojo/rack-base:afab321
LABEL maintainer=jon@jaggersoft.com

WORKDIR /app
COPY Gemfile .

RUN apk add --no-cache \
  libxml2-dev \
  libxslt-dev

RUN apk add --update --upgrade --virtual \
    build-dependencies \
    build-base && \
echo "gem: --no-rdoc --no-ri" > ~/.gemrc && \
bundle install && \
gem clean && \
apk del build-dependencies build-base && \
rm -vrf /usr/lib/ruby/gems/*/cache/* \
        /var/cache/apk/* \
        /tmp/* \
        /var/tmp/*

ARG GIT_COMMIT_SHA
ENV SHA=${GIT_COMMIT_SHA}

RUN apk add --update --upgrade nodejs
