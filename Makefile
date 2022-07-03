.PHONY: \
		run \
		dc-up \
		dc-stop \
		dc-remove \
		dc-reup \
		build_broker \
		build_front \
		start \
		stop \
		fmt \
		vet \
		test \
		testrace \

prepare: fmt vet test testrace

FRONT_END_BINARY=frontApp
BROKER_BINARY=brokerApp

CMD=go
CD=cd

## Makfile using condtional: https://web.mit.edu/gnu/doc/html/make_7.html#:~:text=A%20conditional%20causes%20part%20of,variable%20to%20a%20constant%20string.
CD_TO_TARGET=$(CD) ./$(bin)

## docker-compose
DOCKER_CMD=docker-compose
dc-up: build_broker
	@echo "Starting Docker images..."
	$(DOCKER_CMD) -f ./project/docker-compose.yml up -d
	@echo "Docker images started!"
dc-stop:
	@echo "Stopping docker compose..."
	$(DOCKER_CMD) -f ./project/docker-compose.yml stop
	@echo "Done!"
dc-remove:
	@echo "Removing docker compose..."
	$(DOCKER_CMD) -f ./project/docker-compose.yml down
	@echo "Done!"
dc-reup: build_broker
	@echo "Stopping docker images (if running...)"
	$(DOCKER_CMD) -f ./project/docker-compose.yml down
	@echo "Building (when required) and starting docker images..."
	$(DOCKER_CMD) -f ./project/docker-compose.yml up -d
	@echo "Docker images built and started!"

## build_broker: builds the broker binary as a linux executable
build_broker: prepare
	@echo "Building broker binary..."
	cd ./broker-service && env GOOS=linux CGO_ENABLED=0 go build -o ${BROKER_BINARY} ./cmd/api
	@echo "Done!"

## build_front: builds the frone end binary
build_front: prepare
	@echo "Building front end binary..."
	cd ./front-end && env CGO_ENABLED=0 go build -o ${FRONT_END_BINARY} ./cmd/web
	@echo "Done!"

## start: starts the front end
start: build_front
	@echo "Starting front end"
	cd ./front-end && ./${FRONT_END_BINARY} &

## stop: stop the front end
stop:
	@echo "Stopping front end..."
	@-pkill -SIGTERM -f "./${FRONT_END_BINARY}"
	@echo "Stopped front end!"
fmt:
	@echo "Formatting code..."
	$(CD) ./front-end && go fmt ./...
	$(CD) ./broker-service && go fmt ./...
	@echo "Done"

vet:
	@echo "Vet code..."
	$(CD) ./front-end && go vet ./...
	$(CD) ./broker-service && go vet ./...
	@echo "Done"

test:
	@echo "Running testing..."
	$(CD) ./front-end && go test ./...
	$(CD) ./broker-service && go test ./...
	@echo "Done"

bench:
	@echo "Running benchmark..."
	$(CD) ./front-end && go test -bench=. -run=^$
	$(CD) ./broker-service && go test -bench=. -run=^$
	@echo "Done"

testrace:
	@echo "Running test race..."
	$(CD) ./front-end && go test -race -cpu 1,4 -timeout 7m ./...
	$(CD) ./broker-service && go test -race -cpu 1,4 -timeout 7m ./...
	@echo "Done"
