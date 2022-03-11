FROM ruby:2.7.5

ENV LANG C.UTF-8
ENV DEBCONF_NOWARNINGS yes
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE yes

EXPOSE 3000

RUN apt-get update -qq && apt-get install -y build-essential postgresql-client libpq-dev

RUN apt-get update && apt-get install -y curl apt-transport-https wget && \
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
apt-get update && apt-get install -y yarn

RUN mkdir /rails-app
WORKDIR /rails-app
COPY Gemfile /rails-app/Gemfile
COPY Gemfile.lock /rails-app/Gemfile.lock
RUN bundle install
COPY . /rails-app

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]