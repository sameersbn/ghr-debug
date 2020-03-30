GIT_REPO    = github.com/sameersbn/shaout
GIT_TAG    ?= $(shell git describe --tags --always)
GIT_COMMIT ?= $(shell git rev-parse HEAD)

GO         ?= go
GOFMT      ?= gofmt
GOTEST     ?= go test
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
	$(GOTEST) ./...

fmt:
	$(GOFMT) -s -w $(shell $(GO) list -f '{{$$d := .Dir}}{{range .GoFiles}}{{$$d}}/{{.}} {{end}}' ./...)
	$(GOFMT) -s -w $(shell $(GO) list -f '{{$$d := .Dir}}{{range .TestGoFiles}}{{$$d}}/{{.}} {{end}}' ./...)

vet:
	$(GO) vet ./...

clean:
	$(GO) clean -v
