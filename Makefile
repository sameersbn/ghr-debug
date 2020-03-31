GIT_REPO    = github.com/sameersbn/shaout
GIT_TAG    ?= $(shell git describe --tags --always)
GIT_COMMIT ?= $(shell git rev-parse HEAD)

IMAGE_REPO ?= gcr.io/sameersbn
IMAGE ?= $(IMAGE_REPO)/$(shell basename $(GIT_REPO)):$(GIT_TAG)

GO         ?= go
GOFMT      ?= gofmt
GOTEST     ?= go test
GOTOOL     ?= go tool
LDFLAGS     = -ldflags="-s -w -X $(GIT_REPO)/version.Tag=$(GIT_TAG) -X $(GIT_REPO)/version.Commit=$(GIT_COMMIT)"

.PHONY: build install clean mod-download

all: build

mod-download:
	$(GO) mod download

build:
	$(GO) build $(LDFLAGS) $(GIT_REPO)

install:
	$(GO) install $(LDFLAGS) -v

fmt-test:
	@test -z $(shell $(GOFMT) -l $(shell $(GO) list -f '{{$$d := .Dir}}{{range .GoFiles}}{{$$d}}/{{.}} {{end}}' ./...))
	@test -z $(shell $(GOFMT) -l $(shell $(GO) list -f '{{$$d := .Dir}}{{range .TestGoFiles}}{{$$d}}/{{.}} {{end}}' ./...))

test:
	$(GOTEST) -cover -mod=readonly ./...

coverage:
	$(GOTEST) -cover -coverprofile=c.out ./...
	$(GOTOOL) cover -html=c.out -o coverage.html

fmt:
	$(GOFMT) -s -w $(shell $(GO) list -f '{{$$d := .Dir}}{{range .GoFiles}}{{$$d}}/{{.}} {{end}}' ./...)
	$(GOFMT) -s -w $(shell $(GO) list -f '{{$$d := .Dir}}{{range .TestGoFiles}}{{$$d}}/{{.}} {{end}}' ./...)

vet:
	$(GO) vet ./...

image:
	docker build -t $(IMAGE) . --build-arg GIT_COMMIT=$(GIT_COMMIT) --build-arg GIT_TAG=$(GIT_TAG)

clean:
	$(GO) clean -v
