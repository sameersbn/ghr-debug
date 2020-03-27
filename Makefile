GIT_REPO    = github.com/sameersbn/shaout
GIT_TAG    ?= $(shell git describe --tags --always)
GIT_COMMIT ?= $(shell git rev-parse HEAD)

GO          = go
LDFLAGS     = -ldflags="-s -w -X $(GIT_REPO)/version.Tag=$(GIT_TAG) -X $(GIT_REPO)/version.Commit=$(GIT_COMMIT)"

.PHONY: build install clean

all: build

build:
	$(GO) build $(LDFLAGS) $(GIT_REPO)

install:
	$(GO) install $(LDFLAGS) -v

clean:
	$(GO) clean -v