FROM golang:1.10.0-alpine

RUN apk update && \
    apk upgrade && \
    apk add --no-cache bash git zip

RUN go get -u github.com/aws/aws-sdk-go
RUN go get -u github.com/google/go-github/github
RUN go get -u github.com/aws/aws-lambda-go/lambda
