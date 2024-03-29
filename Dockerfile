FROM ruby:2.6.3

ENV DISCOURSE_VERSION 2.3.1
ENV RUBY_VERSION 2.6.2
ENV DISCOURSE_DB_HOST postgres
ENV DISCOURSE_REDIS_HOST redis
ENV DISCOURSE_SERVE_STATIC_ASSETS true

RUN apt-get update && \
   apt-get -y install git && \
   apt-get -y install build-essential && \
   apt-get -y install libxslt1-dev libcurl4-openssl-dev libksba8 libksba-dev libqtwebkit-dev libreadline-dev libssl-dev zlib1g-dev libsnappy-dev && \
   apt-get -y install libsqlite3-dev sqlite3 && \
   apt-get -y install postgresql postgresql-server-dev-all postgresql-contrib libpq-dev && \
   apt-get -y install redis-server && \
   apt-get -y install curl && \
   apt-get -y install imagemagick && \
   apt-get -y install advancecomp gifsicle jpegoptim libjpeg-progs optipng pngcrush pngquant && \
   apt-get -y install jhead

RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv && \
    printf 'export PATH="$HOME/.rbenv/bin:$PATH"\n' >> ~/.bashrc && \
    printf 'eval "$(rbenv init - --no-rehash)"\n' >> ~/.bashrc

ENV PATH "~/.rbenv/bin:$PATH"
RUN export PATH="$HOME/.rbenv/bin:$PATH" && \
    eval "$(~/.rbenv/bin/rbenv init -)" && \
    git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build && \
    rbenv install "$RUBY_VERSION" && \
    rbenv global $RUBY_VERSION && \
    rbenv rehash && \
    gem update --system && \
    gem install rails && \
    gem install bundler && \
    gem install mailcatcher && \
    curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g svgo

RUN git clone https://github.com/discourse/discourse.git /usr/src/app && \
  cd /usr/src/app && \
  sed -i 's/redis_host = localhost/redis_host = $DISCOURSE_REDIS_HOST/' config/discourse_defaults.conf && \
  cat config/discourse_defaults.conf | grep redis_host && \
  gem install bundler

WORKDIR /usr/src/app
RUN bundle install
RUN gem pristine --all
# Example of install without development
# bundle install --deployment --without test --without development

# Random errors
RUN gem install excon && \
    sed -i 's/uglified, map = Uglifier.new(comments: :none,/uglified, map = Uglifier.new(comments: :none, harmony:true,/' lib/tasks/assets.rake && \
    mkdir -p public/uploads

RUN git clone https://github.com/google/brotli && \
    apt-get install -y cmake libjemalloc-dev && \
    cd brotli && \
    mkdir out && cd out && \
    ../configure-cmake && make && make install

ENV RAILS_ENV=production
ADD run_server.sh /usr/src/app

EXPOSE 80
ADD run_server.sh /usr/src/app
CMD ["/bin/bash", "/usr/src/app/run_server.sh"]
