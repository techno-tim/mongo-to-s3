#! /bin/sh

# exit if a command fails
set -e


apk update

# install mongo

apk add --no-cache mongodb-tools python py-pip

pip install awscli
apk del py-pip
