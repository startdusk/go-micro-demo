FROM alpine:latest

RUN mkdir /app

COPY authApp /app

ENTRYPOINT [ "/app/authApp" ]
