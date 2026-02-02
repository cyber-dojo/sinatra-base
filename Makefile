
SHORT_SHA := $(shell git rev-parse HEAD | head -c7)
IMAGE_NAME := ghcr.io/cyber-dojo/sinatra-base:${SHORT_SHA}

.PHONY: image snyk-container-scan

image:
	${PWD}/bin/build_image.sh

snyk-container-scan:
	snyk container test ${IMAGE_NAME} \
        --file=Dockerfile \
		--sarif \
		--sarif-file-output=snyk.container.scan.json \
        --policy-path=.snyk

