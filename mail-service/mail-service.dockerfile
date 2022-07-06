FROM alpine:latest

RUN mkdir /app

COPY mailApp /app

ENTRYPOINT [ "/app/mailApp" ]
