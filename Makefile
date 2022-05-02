.DEFAULT_GOAL = build

GO := go
version := $(shell ./get-version.sh)

PKG_NAME=env-aws-params

all: build

clean:
	@ $(GO) clean
	@ rm -rf target/

PLATFORMS := linux-amd64 linux-arm64 darwin-amd64

os = $(word 1,$(subst -, ,$@))
arch = $(word 2,$(subst -, ,$@))
platform = $(word 2,$(subst _, ,$@))

$(PLATFORMS): deps
	GOOS=$(os) GOARCH=$(arch) CGO_ENABLED=0 $(GO) build \
		-ldflags "-w -s $(version)" \
		-o target/$(PKG_NAME)_$@

TARGETS = $(addprefix target/$(PKG_NAME)_,$(PLATFORMS))

$(TARGETS):
	make $(platform)

linux: target/env-aws-params_linux-amd64

arm: target/env-aws-params_linux-arm64

macos: target/env-aws-params_darwin-amd64

darwin: target/env-aws-params_darwin-amd64

test:
	$(GO) test

fmt:
	$(GO) fmt

build: fmt test $(TARGETS)

.PHONY: deps build linux
