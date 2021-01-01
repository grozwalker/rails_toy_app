ARG RUBY_VERSION=3.0-alpine
FROM ruby:$RUBY_VERSION

ARG DEBIAN_FRONTEND=noninteractive

ARG NODE_VERSION=12
RUN curl -sL https://deb.nodesource.com/setup_$NODE_VERSION.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && apt-get install -y \
  build-essential \
  nodejs \
  yarn \
  locales \
  git \
  netcat \
  vim \
  sudo \
  postgresql-client

ARG UID
ENV UID $UID
ARG GID
ENV GID $GID

ENV LANG C.UTF-8

ENV BUNDLE_PATH /app/vendor
ENV BUNDLE_HOME /app/vendor

ARG BUNDLE_JOBS=20
ENV BUNDLE_JOBS $BUNDLE_JOBS

ARG BUNDLE_RETRY=5
ENV BUNDLE_RETRY $BUNDLE_RETRY

RUN mkdir -p /app

WORKDIR /app

RUN mkdir -p node_modules && mkdir -p public/packs && mkdir -p tmp/cache && mkdir -p /home/groza/Workspace/rails_app_1

RUN adduser --disabled-password --gecos "" docker-user && \
  echo "docker-user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN chown -R docker-user:docker-user /app

USER docker-user
