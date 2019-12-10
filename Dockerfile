FROM alpine:latest
LABEL maintainer=jon@jaggersoft.com

WORKDIR /app
COPY Gemfile .

# tar is needed to tar-pipe test coverage out of /tmp tmpfs
RUN apk --update --upgrade --no-cache add \
    bash \
    nodejs \
    ruby-dev \
    ruby-bundler \
    tar && \
\
apk add --update --upgrade --virtual \
    build-dependencies \
    build-base && \
echo "gem: --no-rdoc --no-ri" > ~/.gemrc && \
bundle config --global silence_root_warning 1 && \
bundle install && \
gem clean && \
apk del build-dependencies build-base && \
rm -vrf /usr/lib/ruby/gems/*/cache/* \
        /var/cache/apk/* \
        /tmp/* \
        /var/tmp/*
