FROM alpine:latest

RUN mkdir /app

COPY loggerServiceApp /app

ENTRYPOINT [ "/app/loggerServiceApp" ]
