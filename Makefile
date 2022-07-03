.PHONY: run dc

CMD=go
CD=cd

# Makfile using condtional: https://web.mit.edu/gnu/doc/html/make_7.html#:~:text=A%20conditional%20causes%20part%20of,variable%20to%20a%20constant%20string.
# make run bin=front-end
CD_TO_TARGET=$(CD) ./$(bin)
run:
ifeq ($(bin), front-end)
	$(CD_TO_TARGET) && $(CMD) run ./cmd/web/main.go
endif
ifeq ($(bin), broker-service)
	$(CD_TO_TARGET) && $(CMD) run ./cmd/api/main.go
endif

# docker-compose
# make dc cmd=up
DOCKER_CMD=docker-compose
dc:
ifeq ($(cmd), up)
	$(DOCKER_CMD) -f ./project/docker-compose.yml up -d
endif
ifeq ($(cmd), stop)
	$(DOCKER_CMD) -f ./project/docker-compose.yml stop
endif
ifeq ($(cmd), remove)
	$(DOCKER_CMD) -f ./project/docker-compose.yml down
endif