FROM ubuntu:focal

ENV TZ=America/Chicago

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y \
    wget

RUN wget -q https://fastdl.mongodb.org/tools/db/mongodb-database-tools-ubuntu2004-x86_64-100.5.4.deb \
    && apt install -y ./mongodb-database-tools-ubuntu2204-x86_64-100.5.4.deb \
    && rm ./mongodb-database-tools-ubuntu2204-x86_64-100.5.4.deb \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
    awscli \
    && rm -rf /var/lib/apt/lists/*

RUN apt remove -y wget

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
