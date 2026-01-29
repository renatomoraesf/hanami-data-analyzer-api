FROM ruby:3.2.2-slim


RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libsqlite3-dev \
    pkg-config \
    patch \
    python3 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app


COPY Gemfile Gemfile.lock ./
RUN bundle install


COPY . .


RUN mkdir -p log db public tmp/uploads && \
    chmod -R 777 log db tmp

EXPOSE 2300

CMD ["bundle", "exec", "hanami", "server", "--host", "0.0.0.0"]
