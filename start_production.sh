#!/bin/bash
bundle exec rake db:migrate assets:precompile
passenger start -p 5000 -e production
