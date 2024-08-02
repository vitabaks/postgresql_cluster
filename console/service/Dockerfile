FROM golang:1.22.3-bookworm as builder
WORKDIR /go/src/pg-console

COPY console/service/ .

RUN make build_in_docker

FROM debian:bookworm-slim

COPY --from=builder /go/src/pg-console/pg-console /usr/local/bin/
COPY --from=builder /go/src/pg-console/db/migrations /etc/db/migrations

CMD ["/usr/local/bin/pg-console"]
