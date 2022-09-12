# builder image
FROM golang:1.18 as builder

RUN mkdir /build

ADD cmd /build/cmd
ADD go.mod /build
ADD go.sum /build

WORKDIR /build

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build ./cmd/cos-fleet-manager

# final image
FROM registry.access.redhat.com/ubi8/ubi-minimal:8.6

COPY --from=builder /build/cos-fleet-manager /usr/local/bin/
#COPY /build/cos-fleet-manager /usr/local/bin/

EXPOSE 8000

LABEL name="cos-fleet-manager" \
      vendor="Red Hat" \
      version="0.0.1" \
      summary="CosFleetManager" \
      description="Connector Service Fleet Manager"

# executable
ENTRYPOINT [ "/usr/local/bin/cos-fleet-manager" ]
