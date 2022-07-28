CONTAINER_NAME=r-snowflake-lambda-runtime

build:
	DOCKER_BUILDKIT=1 docker build --platform linux/amd64 --build-arg arch=linux/amd64 -t ${CONTAINER_NAME} .

run:
	docker run --platform linux/amd64 -p 8080:8080 -v ~/.aws:/root/.aws ${CONTAINER_NAME}:latest

invoke:
	curl http://localhost:8080/2015-03-31/functions/function/invocations
