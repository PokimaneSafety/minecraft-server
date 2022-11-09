ARG GO_VERSION=1.19
ARG ALPINE_VERSION=3.16

FROM golang:${GO_VERSION}-alpine${ALPINE_VERSION} as builder
WORKDIR /app
COPY go.mod ./
RUN go mod download && go mod verify
COPY . .
RUN go build -v -o ./deployerd ./cmd/deployerd/...

FROM alpine:${ALPINE_VERSION}
WORKDIR /app
RUN apk update && \
    apk add --no-cache curl docker-compose
ARG GO_VERSION
ADD https://github.com/golang/go/raw/release-branch.go${GO_VERSION}/lib/time/zoneinfo.zip /zoneinfo.zip
ENV ZONEINFO /zoneinfo.zip
COPY --from=builder /app/deployerd .
CMD ./deployerd
