FROM golang:1.10.0-alpine

# Install the neccessary packages for bulding the binary.
RUN apk update && \
    apk upgrade && \
    apk add --no-cache bash git zip

# The the packages for go.
RUN go get -u github.com/aws/aws-sdk-go
RUN go get -u github.com/google/go-github/github
RUN go get -u github.com/aws/aws-lambda-go/lambda
