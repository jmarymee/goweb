FROM golang:1.11 AS build-env

WORKDIR /go/src/webapp
COPY . .

#get and build
RUN go get -d -v ./...
#RUN go install -v ./...
RUN CGO_ENABLED=0 GOOS=linux go install -a webapp

#test
RUN go test

#build runtime image
FROM alpine:3.8
# Root Certificates needed for making https/ssl requests
# Bash needed for Kubernetes Dashboard Shell access
RUN apk update && \
  apk add ca-certificates && \
  update-ca-certificates
WORKDIR /go/bin
COPY --from=build-env /go/bin .

CMD ["./webapp"]
