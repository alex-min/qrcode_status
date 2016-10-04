#!/bin/bash
if [ -z "$2" ]; then
    echo "USAGE: $0 [hostname] [application name]";
    exit 1;
fi
set -o xtrace
DOKKU_HOST="$1"
APPNAME="$2"
ssh "dokku@$DOKKU_HOST" apps:create "$APPNAME"
ssh "dokku@$DOKKU_HOST" config:set --no-restart "$APPNAME" `cat .env`
ssh "dokku@$DOKKU_HOST" postgres:create "$APPNAME"
ssh "dokku@$DOKKU_HOST" postgres:link "$APPNAME" "$APPNAME"
git remote add "$APPNAME" "dokku@$DOKKU_HOST:$APPNAME"
git push "$APPNAME"
ssh "dokku@$DOKKU_HOST" config:set --no-restart "$APPNAME" DOKKU_LETSENCRYPT_EMAIL=minettealexandre@fastmail.se
ssh "dokku@$DOKKU_HOST" letsencrypt "$APPNAME"

