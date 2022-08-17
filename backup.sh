#! /bin/sh

mongodump --version
 
set -eo pipefail

if [ "${S3_ACCESS_KEY_ID}" == "**None**" ]; then
  echo "Warning: You did not set the S3_ACCESS_KEY_ID environment variable."
fi

if [ "${S3_SECRET_ACCESS_KEY}" == "**None**" ]; then
  echo "Warning: You did not set the S3_SECRET_ACCESS_KEY environment variable."
fi

if [ "${S3_BUCKET}" == "**None**" ]; then
  echo "You need to set the S3_BUCKET environment variable."
  exit 1
fi

if [ "${MONGO_HOST}" == "**None**" ]; then
  echo "You need to set the MONGO_HOST environment variable."
  exit 1
fi

if [ "${MONGO_USER}" == "**None**" ]; then
  echo "You need to set the MONGO_USER environment variable."
  exit 1
fi

if [ "${MONGODUMP_DATABASE}" == "**None**" ]; then
  echo "Backing up all databases since none was provided."
fi

if [ "${MONGO_PASSWORD}" == "**None**" ]; then
  echo "You need to set the MONGO_PASSWORD environment variable or link to a container named MONGO."
  exit 1
fi

if [ "${S3_IAMROLE}" != "true" ]; then
  # env vars needed for aws tools - only if an IAM role is not used
  export AWS_ACCESS_KEY_ID=$S3_ACCESS_KEY_ID
  export AWS_SECRET_ACCESS_KEY=$S3_SECRET_ACCESS_KEY
  export AWS_DEFAULT_REGION=$S3_REGION
fi

MONGO_SAFE_HOST_OPTS="--host $MONGO_HOST --port=$MONGO_PORT --username=$MONGO_USER"
MONGO_HOST_OPTS="$MONGO_SAFE_HOST_OPTS --password=$MONGO_PASSWORD"
DUMP_START_TIME=$(date +"%Y-%m-%dT%H%M%SZ")

copy_s3 () {
  SRC_FILE=$1
  DEST_FILE=$2

  if [ "${S3_ENDPOINT}" == "**None**" ]; then
    AWS_ARGS=""
  else
    AWS_ARGS="--endpoint-url ${S3_ENDPOINT}"
  fi

  echo "Uploading ${DEST_FILE} on S3..."

  cat $SRC_FILE | aws $AWS_ARGS s3 cp - s3://$S3_BUCKET/$S3_PREFIX/$DEST_FILE

  if [ $? != 0 ]; then
    >&2 echo "Error uploading ${DEST_FILE} on S3"
  fi

  rm $SRC_FILE
}
echo "Creating dump for ${MONGODUMP_DATABASE} from ${MONGO_HOST}..."

if [ "${MONGODUMP_DATABASE}" == "**None**" ]; then
  MONGODUMP_DATABASE_ARG=""
else 
  MONGODUMP_DATABASE_ARG="--db=$MONGODUMP_DATABASE"
fi

DUMP_FILE="/tmp/dump.mongo.gz"
echo "Command: mongodump $MONGO_SAFE_HOST_OPTS --password=xxx $MONGODUMP_OPTIONS $MONGODUMP_DATABASE_ARG --gzip --archive=$DUMP_FILE"
set +e
mongodump $MONGO_HOST_OPTS $MONGODUMP_OPTIONS $MONGODUMP_DATABASE_ARG --gzip --archive=$DUMP_FILE
ret=$?
set -e


if [ $ret == 0 ]; then
    S3_FILE="${DUMP_START_TIME}.${MONGODUMP_DATABASE}.mongo.gz"

    copy_s3 $DUMP_FILE $S3_FILE
else
    >&2 echo "Error creating dump of all databases"
    exit $ret
fi

echo "Mongo backup finished"
