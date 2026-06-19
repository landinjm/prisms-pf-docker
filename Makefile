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

minimal-dependencies-merge:
	docker buildx imagetools create -t landinjm/prisms-pf-dependencies:alpine-minimal \
		landinjm/prisms-pf-dependencies:alpine-minimal-arm64 \
		landinjm/prisms-pf-dependencies:alpine-minimal-amd64

# Build the minimal PRISMS-PF amd64 variant
master-minimal-amd64:
	$(DOCKER_BUILD) \
		--platform linux/amd64 \
		-t landinjm/prisms-pf:alpine-minimal-amd64 \
		--build-arg NJOBS=${NJOBS} \
		--build-arg ALL_DEPENDENCIES=OFF \
		--build-arg IMG=alpine-minimal-amd64 \
		./prisms-pf

# Build the minimal PRISMS-PF arm64 variant
master-minimal-arm64:
	$(DOCKER_BUILD) \
		--platform linux/arm64 \
		-t landinjm/prisms-pf:alpine-minimal-arm64 \
		--build-arg NJOBS=${NJOBS} \
		--build-arg ALL_DEPENDENCIES=OFF \
		--build-arg IMG=alpine-minimal-arm64 \
		./prisms-pf

master-minimal-merge:
	docker buildx imagetools create -t landinjm/prisms-pf:alpine-minimal \
		landinjm/prisms-pf:alpine-minimal-arm64 \
		landinjm/prisms-pf:alpine-minimal-amd64

minimal-dependencies: minimal-dependencies-amd64 minimal-dependencies-arm64 minimal-dependencies-merge

master-minimal: master-minimal-amd64 master-minimal-arm64 master-minimal-merge

all: minimal-dependencies master-minimal

.PHONY: all \
	minimal-dependencies \
	minimal-dependencies-amd64 \
	minimal-dependencies-arm64 \
	minimal-dependencies-merge \
	master-minimal \
	master-minimal-amd64 \
	master-minimal-arm64 \
	master-minimal-merge
