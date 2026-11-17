ARG GO_VERSION
FROM golang:${GO_VERSION} AS build

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .

ARG VERSION=dev
ARG COMMIT=none
ARG BUILDTIME=unknown
RUN CGO_ENABLED=0 go build \
    -ldflags "-s -w -X main.Version=${VERSION} -X main.Commit=${COMMIT} -X main.BuildTime=${BUILDTIME}" \
    -o /asset-watcher .

FROM gcr.io/distroless/static-debian12:nonroot

COPY --from=build /asset-watcher /asset-watcher
CMD ["/asset-watcher"]
