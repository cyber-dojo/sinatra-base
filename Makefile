
SHORT_SHA := $(shell git rev-parse HEAD | head -c7)
IMAGE_NAME := cyberdojo/sinatra-base:${SHORT_SHA}

.PHONY: image snyk-container-scan

image:
	${PWD}/sh/build_image.sh

snyk-container-scan:
	snyk container test ${IMAGE_NAME} \
        --file=Dockerfile \
		--sarif \
		--sarif-file-output=snyk.container.scan.json \
        --policy-path=.snyk

