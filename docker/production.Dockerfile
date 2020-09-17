ARG RUBY_VERSION=2.7
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

ENV LANG C.UTF-8

ENV BUNDLE_PATH /gems
ENV BUNDLE_HOME /gems

ARG BUNDLE_JOBS=20
ENV BUNDLE_JOBS $BUNDLE_JOBS

ARG BUNDLE_RETRY=5
ENV BUNDLE_RETRY $BUNDLE_RETRY

ENV GEM_HOME /gems
ENV GEM_PATH /gems

ENV PATH /gems/bin:$PATH

ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
WORKDIR /usr/src/app/
RUN bundle config --global frozen 1
RUN bundle config set without 'development test'
RUN bundle install

COPY . /usr/src/app
RUN bundle exec rake DATABASE_URL=postgresql:does_not_exist assets:precompile

EXPOSE 3000
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
