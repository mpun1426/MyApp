FROM ruby:2.7.3

RUN wget --quiet -O - /tmp/pubkey.gpg https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update -y -qq && apt-get install -yq yarn imagemagick
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get install -y nodejs
RUN apt-get update
RUN apt-get install -y vim
RUN mkdir /MyApp
WORKDIR /MyApp
COPY . /MyApp
RUN bundle config --local set path 'vendor/bundle' && bundle install
RUN bundle config set --global force_ruby_platform true && bundle install

# Add a script to be executed every time the container starts.
# COPY entrypoint.sh /usr/bin/
# RUN chmod +x /usr/bin/entrypoint.sh
# ENTRYPOINT ["entrypoint.sh"]
