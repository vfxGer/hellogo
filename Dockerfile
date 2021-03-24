############################
# STEP 1 build executable binary
############################
FROM golang AS builder

WORKDIR $GOPATH/src/mypackage/myapp/
COPY . .
# Build the binary.
RUN go build -o /go/bin/hello
############################
# STEP 2 build a small image
############################
FROM scratch
# Copy our static executable.
COPY --from=builder /go/bin/hello /go/bin/hello
# Run the hello binary.
CMD ["/go/bin/hello"]
