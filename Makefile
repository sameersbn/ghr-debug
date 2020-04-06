PACKAGE     = shaout

GIT_REPO    = github.com/sameersbn/$(PACKAGE)
GIT_TAG    ?= $(shell git describe --tags --always)
GIT_COMMIT ?= $(shell git rev-parse HEAD)

IMAGE_REPO ?= gcr.io/sameersbn
IMAGE      ?= $(IMAGE_REPO)/$(shell basename $(GIT_REPO)):$(GIT_TAG)

GO         ?= go
GOFMT      ?= gofmt
GOTEST     ?= gotestsum --junitfile $(OUTPUT_DIR)$(PACKAGE)-unit-tests.xml --
GOTOOL     ?= go tool
LDFLAGS    += -s -w -X $(GIT_REPO)/version.Tag=$(GIT_TAG) -X $(GIT_REPO)/version.Commit=$(GIT_COMMIT)

.PHONY: build install clean mod-download

all: build

help: ## Display this help
	@awk 'BEGIN {FS = ":.*?## "; printf "\n$(PACKAGE_DESC)\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z0-9._-]+:.*?## / {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

mod-download: ## Download go modules
	$(GO) mod download

build: ## Build the binary
	$(GO) build -ldflags="$(LDFLAGS)" $(GIT_REPO)

install: ## Install the binary
	$(GO) install -ldflags="$(LDFLAGS)" -v

test: ## Run unit tests
	$(GOTEST) -coverprofile=c.out ./...

coverage: ## Generate code coverage
	$(GOTOOL) cover -html=c.out -o $(OUTPUT_DIR)$(PACKAGE)-coverage.html

lint: ## Link source files
	$(GOLINT) ./...

vet: ## Vet source files
	$(GO) vet ./...

fmt: ## Format source files
	$(GOFMT) -s -w $(shell $(GO) list -f '{{$$d := .Dir}}{{range .GoFiles}}{{$$d}}/{{.}}{{end}} {{$$d := .Dir}}{{range .TestGoFiles}}{{$$d}}/{{.}}{{end}}' ./...)

fmt-test: ## Check source formatting
	@test -z $(shell $(GOFMT) -l $(shell $(GO) list -f '{{$$d := .Dir}}{{range .GoFiles}}{{$$d}}/{{.}}{{end}} {{$$d := .Dir}}{{range .TestGoFiles}}{{$$d}}/{{.}}{{end}}' ./...))

image:
	docker build -t $(IMAGE) . --build-arg GIT_COMMIT=$(GIT_COMMIT) --build-arg GIT_TAG=$(GIT_TAG)

clean: ## Clean build artifacts
	@$(RM) -rf $(PACKAGE)
	rm -rf $(PACKAGE)-unit-tests.xml
	rm -rf c.out $(PACKAGE)-coverage.html
