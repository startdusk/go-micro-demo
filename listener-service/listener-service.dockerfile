FROM alpine:latest

RUN mkdir /app

COPY listenerApp /app

ENTRYPOINT [ "/app/listenerApp" ]
