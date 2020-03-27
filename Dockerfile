FROM golang:1.13 AS builder

ENV CGO_ENABLED=0
ENV GOOS=linux
ENV GOARCH=amd64

ARG GIT_COMMIT
ARG GIT_TAG

ENV GIT_TAG=${GIT_TAG}
ENV GIT_COMMIT=${GIT_COMMIT}

WORKDIR /go/src/github.com/sameersbn/shaout

COPY . .

RUN make install
RUN /go/bin/shaout

FROM scratch

COPY --from=builder /go/bin/shaout /bin/

ENTRYPOINT ["/bin/shaout"]
