FROM ruby:2.6

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock firewall-on firewall-off server.rb ./
RUN bundle install


