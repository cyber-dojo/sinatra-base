FROM cyberdojo/rack-base:be46d16
LABEL maintainer=jon@jaggersoft.com

RUN apk add nodejs

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

ARG GIT_COMMIT_SHA

ENV SHA=${GIT_COMMIT_SHA}

