FROM golang:1.13 AS builder

ENV CGO_ENABLED=0
ENV GOOS=linux
ENV GOARCH=amd64

WORKDIR /go/src/github.com/sameersbn/shaout
COPY go.mod go.sum /go/src/github.com/sameersbn/shaout/
RUN go mod download

ARG GIT_COMMIT
ARG GIT_TAG

ENV GIT_COMMIT=${GIT_COMMIT:-unknown}
ENV GIT_TAG=${GIT_TAG:-unknown}

COPY . .

RUN make install

FROM scratch

COPY --from=builder /go/bin/shaout /bin/

ENTRYPOINT ["/bin/shaout"]
