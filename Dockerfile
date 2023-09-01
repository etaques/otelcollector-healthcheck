FROM golang:1.19-alpine AS builder

WORKDIR /go/src/healthcheck
COPY go.mod .
RUN go mod tidy
COPY . .
RUN apk update && apk add make build-base git
RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o healthcheck
RUN chmod a+x /go/src/healthcheck/run.sh

FROM alpine:latest
RUN apk --update add ca-certificates logrotate cron
COPY --from=builder /go/src/healthcheck/healthcheck /healthcheck
COPY --from=builder /go/src/healthcheck/run.sh /run.sh

ENTRYPOINT [ "/run.sh" ]