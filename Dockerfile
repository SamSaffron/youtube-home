FROM ruby:3.1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock firewall-on firewall-off internet-on internet-off server.rb ./
RUN gem install bundler
RUN bundle install

RUN mkdir /root/.ssh
COPY id_rsa.pub id_rsa /root/.ssh/

RUN chmod 700 /root/.ssh
RUN chmod 600 /root/.ssh/id_rsa
RUN chmod 644 /root/.ssh/id_rsa.pub

ENV APP_ENV production
EXPOSE 4567

CMD bundle exec ruby server.rb

