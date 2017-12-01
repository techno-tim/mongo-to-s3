FROM alpine:latest

COPY install.sh install.sh
RUN sh install.sh && rm install.sh

ENV MONGODUMP_OPTIONS=""
ENV MONGODUMP_DATABASE **None**
ENV MONGO_HOST **None**
ENV MONGO_PORT 27017
ENV MONGO_USER **None**
ENV MONGO_PASSWORD **None**
ENV S3_ACCESS_KEY_ID **None**
ENV S3_SECRET_ACCESS_KEY **None**
ENV S3_BUCKET **None**
ENV S3_REGION eu-west-1
ENV S3_ENDPOINT **None**
ENV S3_S3V4 no
ENV S3_PREFIX 'backup'

ADD run.sh run.sh
ADD backup.sh backup.sh

ENTRYPOINT [ "sh", "run.sh" ] 
CMD ["sh", "backup.sh"]
