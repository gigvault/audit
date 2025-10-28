FROM golang:1.23-bullseye AS builder
WORKDIR /src

# Copy shared library first
COPY shared/ ./shared/

# Copy service files
COPY audit/go.mod audit/go.sum ./audit/
WORKDIR /src/audit
RUN go mod download

WORKDIR /src
COPY audit/ ./audit/
WORKDIR /src/audit
RUN CGO_ENABLED=0 GOOS=linux go build -o /out/audit ./cmd/audit

FROM alpine:3.18
RUN apk add --no-cache ca-certificates
COPY --from=builder /out/audit /usr/local/bin/audit
COPY audit/config/ /config/
EXPOSE 8080 9090
ENTRYPOINT ["/usr/local/bin/audit"]
