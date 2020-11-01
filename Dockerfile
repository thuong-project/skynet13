FROM ruby:2.7.1

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client npm
RUN npm install -g yarn

RUN mkdir /myapp
COPY . /myapp


ENV BUNDLE_PATH /myapp/bundle
ENV BUNDLE_BIN /myapp/bundle/bin 


WORKDIR /myapp

RUN bundle install
RUN bundle exec rake assets:precompile

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000


CMD ["bundle", "exec", "rails", "server"]
