FROM cyberdojo/rack-base:8fb133a
LABEL maintainer=jon@jaggersoft.com

ARG SHA
ENV SHA=${SHA}

WORKDIR /app
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

RUN apk add --update --upgrade nodejs
