FROM ruby:2.6.2-alpine3.9

RUN apk add --no-cache git

WORKDIR /home/app

CMD ["/sbin/my_init"]

COPY lib/payoneer/version.rb /home/app/lib/payoneer/
COPY payoneer-ruby.gemspec /home/app/
COPY Gemfile* /home/app/
RUN bundle config --global silence_root_warning 1 \
      && bundle install --retry=4 --jobs=4

ADD . /home/app
