FROM golang:1.9.2-alpine

RUN apk update && \
    apk upgrade && \
    apk add --no-cache bash git

RUN go get -u github.com/aws/aws-sdk-go
RUN go get -u github.com/google/go-github/github
