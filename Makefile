CMD=go

# Makfile using condtional: https://web.mit.edu/gnu/doc/html/make_7.html#:~:text=A%20conditional%20causes%20part%20of,variable%20to%20a%20constant%20string.
run:
ifeq ($(bin), front-end)
	$(CMD) run ./$(bin)/cmd/web/main.go
endif
ifeq ($(bin), broker-service)
	$(CMD) run ./$(bin)/cmd/api/main.go
endif

docker-compose:
	docker-compose up -d ./project