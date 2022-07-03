# base go image
# FROM golang:1.18-alpine AS builder

# RUN mkdir /app

# COPY . /app

# WORKDIR /app

# RUN go env -w GOPROXY=https://goproxy.cn
# RUN go mod download


# RUN CGO_ENABLED=0 go build -o brokerApp ./cmd/api

# RUN chmod +x /app/brokerApp

# # build a tiny docker image 
# FROM alpine:latest

# RUN mkdir /app

# COPY --from=builder /app/brokerApp /app

# ENTRYPOINT [ "/app/brokerApp" ]

# using local build binary
FROM alpine:latest

RUN mkdir /app

COPY brokerApp /app

ENTRYPOINT [ "/app/brokerApp" ]
