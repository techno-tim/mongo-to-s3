# mongo-to-s3

[![Docker Build Status](https://img.shields.io/docker/pulls/timothystewart6/mongo-to-s3.svg)](https://hub.docker.com/r/timothystewart6/mongo-to-s3/)

Backup MongoDB to S3, built for [minio](https://minio.io)

Based on [Mysql Backup S3](https://hub.docker.com/r/schickling/mysql-backup-s3/)

## Basic usage

```sh
docker run \
  -e S3_ACCESS_KEY_ID=key \
  -e S3_SECRET_ACCESS_KEY=secret \
  -e S3_BUCKET=my-bucket \
  -e S3_PREFIX=backup \
  -e MONGO_USER=user \
  -e MONGO_PASSWORD=password \
  -e MONGO_HOST=localhost \
  -e MONGODUMP_DATABASE=todos \
  timothystewart6/mongo-to-s3
```

## Environment Variables

- `MONGODUMP_OPTIONS` mongodump options (default: )
- `MONGODUMP_DATABASE` list of databases you want to backup *optional* (default all)
- `MONGO_HOST` the mongo host *required*
- `MONGO_USER` the mongo user *required*
- `MONGO_PASSWORD` the mongo password *required*
- `S3_ACCESS_KEY_ID` your AWS access key *required*
- `S3_SECRET_ACCESS_KEY` your AWS secret key *required*
- `S3_BUCKET` your AWS S3 bucket path *required*
- `S3_PREFIX` path prefix in your bucket (default: 'backup')
- `S3_REGION` the AWS S3 bucket region (default: eu-west-1)
- `S3_ENDPOINT` the AWS Endpoint URL, for S3 Compliant APIs such as [minio](https://minio.io) (default: none)
- `S3_S3V4` set to `yes` to enable AWS Signature Version 4, required for [minio](https://minio.io) servers (default: no)

## .env

See `.env.example` for ENVs
