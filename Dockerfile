FROM cyberdojo/rack-base:f061e73
LABEL maintainer=jon@jaggersoft.com

WORKDIR /app

# Install nokogiri dependencies
RUN apk --update --upgrade add \
  libxml2-dev \
  libxslt-dev \
  postgresql-dev

# Install nokogiri (won't install from Gemfile)
RUN apk add --update --upgrade --virtual \
  build-base \
  && bundle config build.nokogiri --use-system-libraries \
  && apk del build-base \
  && rm -vrf /usr/lib/ruby/gems/*/cache/* \
             /var/cache/apk/* \
             /tmp/* \
             /var/tmp/*

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

ARG GIT_COMMIT_SHA

ENV SHA=${GIT_COMMIT_SHA}

RUN apk add --update --upgrade nodejs
