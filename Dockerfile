FROM cyberdojo/rack-base:90d831c
LABEL maintainer=jon@jaggersoft.com

WORKDIR /app

RUN apk --update --upgrade add tar

RUN apk add --update \
  build-base \
  libxml2-dev \
  libxslt-dev \
  postgresql-dev \
  && rm -rf /var/cache/apk/* \
  && bundle config build.nokogiri --use-system-libraries

COPY Gemfile .

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
