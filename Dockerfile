FROM madetech/rails-deps

RUN mkdir -p /app
RUN apt-get update
RUN apt-get install wget -y
RUN wget http://binaries.html-tidy.org/binaries/tidy-5.2.0/tidy-5.2.0-64bit.deb -O /tmp/tidy.deb
RUN dpkg -i /tmp/tidy.deb
WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 20 --retry 5
EXPOSE 3000
CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0", "-p", "3000"]
