# TODO Ruby version to variable

FROM ruby:3.0-alpine AS build-env

ARG RAILS_ROOT=/app
ARG BUILD_PACKAGES="build-base curl-dev git"
ARG DEV_PACKAGES="postgresql-dev yaml-dev zlib-dev nodejs yarn sqlite sqlite-dev"
ARG RUBY_PACKAGES="tzdata"
ARG RAILS_MASTER_KEY

ENV RAILS_ENV=production
ENV NODE_ENV=production
ENV BUNDLE_APP_CONFIG="$RAILS_ROOT/.bundle"
ENV RAILS_MASTER_KEY=${RAILS_MASTER_KEY}

WORKDIR $RAILS_ROOT

# install packages
RUN apk update \
    && apk upgrade \
    && apk add --update --no-cache $BUILD_PACKAGES $DEV_PACKAGES $RUBY_PACKAGES

COPY Gemfile* package.json yarn.lock ./

# install rubygem
COPY Gemfile Gemfile.lock $RAILS_ROOT/

RUN bundle config --global frozen 1 \
    && bundle config set without 'development:test:assets' \
    && bundle install -j4 --retry 3 --path=vendor/bundle \
    # Remove unneeded files (cached *.gem, *.o, *.c)
    && rm -rf vendor/bundle/ruby/2.7.0/cache/*.gem \
    && find vendor/bundle/ruby/2.7.0/gems/ -name "*.c" -delete \
    && find vendor/bundle/ruby/2.7.0/gems/ -name "*.o" -delete
RUN yarn install --production

COPY . .

RUN bin/rails webpacker:compile
RUN bin/rails assets:precompile

# Remove folders not needed in resulting image
# RUN rm -rf node_modules tmp/cache vendor/assets spec


############### Build step done ###############
FROM ruby:3.0-alpine

ARG RAILS_ROOT=/app
ARG PACKAGES="tzdata postgresql-client nodejs bash sqlite sqlite-dev"

ENV RAILS_ENV=production
ENV BUNDLE_APP_CONFIG="$RAILS_ROOT/.bundle"

WORKDIR $RAILS_ROOT

# install packages
RUN apk update \
    && apk upgrade \
    && apk add --update --no-cache $PACKAGES

COPY --from=build-env $RAILS_ROOT $RAILS_ROOT

EXPOSE 3000

CMD ["bin/rails", "server", "-b", "0.0.0.0"]
