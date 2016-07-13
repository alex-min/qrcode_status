FROM ruby:2.2.5

RUN env
RUN mkdir -p /app
RUN apt-get update
RUN apt-get install wget nodejs -y
RUN wget http://binaries.html-tidy.org/binaries/tidy-5.2.0/tidy-5.2.0-64bit.deb -O /tmp/tidy.deb
RUN wget http://download.gna.org/wkhtmltopdf/0.12/0.12.3/wkhtmltox-0.12.3_linux-generic-amd64.tar.xz -O /tmp/webkit.tar.gz
RUN mkdir /tmp/webkit
RUN tar -xvf /tmp/webkit.tar.gz -C /tmp/webkit
RUN cp -R /tmp/webkit/wkhtmltox/* /
RUN dpkg -i /tmp/tidy.deb
WORKDIR /app
COPY Gemfile Gemfile.lock unicorn.conf ./
RUN bundle install --jobs 20 --retry 5
EXPOSE 80
ADD . /app
CMD ["bundle", "exec", "thin", "start", "-p", "80"]
