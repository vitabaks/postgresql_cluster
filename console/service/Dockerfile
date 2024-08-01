FROM golang:1.22.3-bookworm as builder
WORKDIR /go/src/pg-console

COPY . .

RUN make build_in_docker

FROM debian:bookworm-slim

ENV PROJECT_NAME=pg-console
ENV PROJECT_PATH=/go/src/${PROJECT_NAME}

COPY --from=builder ${PROJECT_PATH}/${PROJECT_NAME} /usr/local/bin/
COPY --from=builder ${PROJECT_PATH}/db/migrations /etc/db/migrations

CMD ${PROJECT_NAME}
