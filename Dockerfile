FROM ruby:2.7.1
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client npm
RUN npm install -g yarn
RUN mkdir /myapp
WORKDIR /myapp
ENV BUNDLE_PATH=/bundle \
        BUNDLE_BIN=/bundle/bin \
        GEM_HOME=/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"
