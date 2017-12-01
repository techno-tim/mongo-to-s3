TAG=$(shell echo $${TAG:-master})
build:
	docker build -t registry.sendify.se/mongo-to-s3:$(TAG) .

push:
	docker push registry.sendify.se/mongo-to-s3:$(TAG)
