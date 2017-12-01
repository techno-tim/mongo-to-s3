#! /bin/sh

# exit if a command fails
set -e


apk update

# install mongo

apk add --no-cache mongodb python py-pip
rm /usr/bin/mongoperf

pip install awscli
apk del py-pip
