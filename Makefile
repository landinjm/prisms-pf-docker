# Grab the arch
ARCH=$(shell uname -m)
ifeq ($(ARCH),arm64)
PLATFORM=linux/arm64
else ifeq ($(ARCH),x86_64)
PLATFORM=linux/amd64
ARCH=amd64
endif

# Grab the number of jobs
NJOBS ?= 0
ifeq ($(NJOBS),0)
NJOBS=$(shell nproc)
endif

# Docker build command
DOCKER_BUILD=docker buildx build --push

# Build the minimal dependencies amd64 variant
minimal-dependencies-amd64:
	$(DOCKER_BUILD) \
		--platform linux/amd64 \
		-t landinjm/prisms-pf-dependencies:alpine-minimal-amd64 \
		--build-arg NJOBS=${NJOBS} \
		--build-arg ALL_DEPENDENCIES=OFF \
		./dependencies

# Build the minimal dependencies arm64 variant
minimal-dependencies-arm64:
	$(DOCKER_BUILD) \
		--platform linux/arm64 \
		-t landinjm/prisms-pf-dependencies:alpine-minimal-arm64 \
		--build-arg NJOBS=${NJOBS} \
		--build-arg ALL_DEPENDENCIES=OFF \
		./dependencies

minimal-dependencies-merge::
	docker buildx imagetools create -t landinjm/prisms-pf-dependencies:alpine-minimal \
		landinjm/prisms-pf-dependencies:alpine-minimal-arm64 \
		landinjm/prisms-pf-dependencies:alpine-minimal-amd64

minimal-dependencies: minimal-dependencies-amd64 minimal-dependencies-arm64 minimal-dependencies-merge

all: minimal-dependencies

.PHONY: all \
	dependencies \
	minimal-dependencies-amd64 \
	minimal-dependencies-arm64 \
	minimal-dependencies-merge
