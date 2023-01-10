FROM ruby:3.0.2-alpine3.13

RUN apk add --no-cache --update build-base linux-headers nodejs postgresql-dev postgresql-client tzdata

RUN mkdir /app
WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN bundle install

COPY . /app

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]