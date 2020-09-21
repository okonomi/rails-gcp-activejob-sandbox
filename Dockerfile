FROM ruby:2.7.1-slim-buster as builder

ENV BUNDLE_FROZEN true
ENV BUNDLE_JOBS 4
ENV BUNDLE_PATH /app/vendor/bundle
ENV BUNDLE_WITHOUT development:test

WORKDIR /app

RUN apt-get update \
 && apt-get install -y --no-install-recommends build-essential libsqlite3-dev curl gnupg \
 && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
 && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
 && apt-get update \
 && apt-get install -y --no-install-recommends yarn nodejs

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN bundle install --verbose
RUN yarn --frozen-lockfile


FROM ruby:2.7.1-slim-buster as production

ENV PORT 3000
ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true
ENV BUNDLE_PATH /app/vendor/bundle
ENV BUNDLE_WITHOUT development:test

WORKDIR /app

RUN apt-get update \
 && apt-get install -y --no-install-recommends libsqlite3-dev \
 && rm -rf /var/lib/apt/lists/

COPY . /app
COPY --from=builder /app/vendor/bundle vendor/bundle
COPY --from=builder /app/node_modules node_modules

CMD bin/rails s -b 0.0.0.0 -p $PORT
