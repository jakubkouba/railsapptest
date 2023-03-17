FROM ruby:3.0.5-slim AS builder

# RUN adduser rails-app
# USER rails-app

RUN apt-get update -qq && apt-get install -y \
gcc \
libxml2-dev \
libxslt-dev \
make \
pkg-config \
ruby-dev

FROM builder as bundler
WORKDIR /app

RUN gem install bundler --default -v 2.4.3
RUN bundle config --global build.nokogiri --use-system-libraries --platform=ruby

COPY Gemfile Gemfile.lock /app/

FROM bundler as gem-cache-prod
WORKDIR /app

RUN bundle config set --local without 'development test' && bundle install

FROM bundler as gem-cache-test
WORKDIR /app

RUN bundle config set --local without 'development' && bundle install

FROM builder as prod
WORKDIR /app

COPY --from=gem-cache-prod /usr/local/bundle /usr/local/bundle
COPY . /app

# # Add a script to be executed every time the container starts.
COPY bin/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
ENV RAILS_ENV=production

# Configure the main process to run when running the image
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
# CMD ["sleep", "3600"]

FROM builder as test
WORKDIR /app

COPY --from=gem-cache-test /usr/local/bundle /usr/local/bundle
COPY . /app

CMD rspec