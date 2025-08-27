ARCH=$(shell uname -m)
ifeq ($(ARCH),arm64)
PLATFORM=linux/arm64
else ifeq ($(ARCH),x86_64)
PLATFORM=linux/amd64
ARCH=amd64
endif

NJOBS ?= 0
ifeq ($(NJOBS),0)
NJOBS=$(shell nproc)
endif

DOCKER_BUILD=docker buildx build

# Build amd64 variant
dependencies-amd64:
	$(DOCKER_BUILD) \
		--platform linux/amd64 \
		-t landinjm/prisms-pf-dependencies:alpine-amd64 \
		--build-arg NJOBS=${NJOBS} \
		./dependencies

# Build arm64 variant
dependencies-arm64:
	$(DOCKER_BUILD) \
		--platform linux/arm64 \
		-t landinjm/prisms-pf-dependencies:alpine-arm64 \
		--build-arg NJOBS=${NJOBS} \
		./dependencies

dependencies-merge::
	docker buildx imagetools create -t landinjm/prisms-pf-dependencies:alpine \
		landinjm/prisms-pf-dependencies:alpine-arm64 \
		landinjm/prisms-pf-dependencies:alpine-amd64

dependencies: dependencies-amd64 dependencies-arm64 dependencies-merge

all: dependencies

.PHONY: all \
	dependencies \
	dependencies-amd64 \
	dependencies-arm64 \
	dependencies-merge