FROM madetech/rails-deps

RUN mkdir -p /app
RUN apt-get update
RUN apt-get install wget -y
RUN wget http://binaries.html-tidy.org/binaries/tidy-5.2.0/tidy-5.2.0-64bit.deb -O /tmp/tidy.deb
RUN wget http://download.gna.org/wkhtmltopdf/0.12/0.12.3/wkhtmltox-0.12.3_linux-generic-amd64.tar.xz -O /tmp/webkit.tar.gz
RUN mkdir /tmp/webkit
RUN tar -xvf /tmp/webkit.tar.gz -C /tmp/webkit
RUN cp -R /tmp/webkit/wkhtmltox/* /
RUN dpkg -i /tmp/tidy.deb
WORKDIR /app
COPY Gemfile Gemfile.lock unicorn.conf ./
RUN bundle install --jobs 20 --retry 5
RUN bundle exec rake db:migrate
RUN bundle exec rake db:seed
EXPOSE 3000
CMD ["unicorn_rails", "-p", "3000", "-c", "unicorn.conf"]
#CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0", "-p", "3000"]
