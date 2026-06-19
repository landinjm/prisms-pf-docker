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

minimal-dependencies-%:
	$(DOCKER_BUILD) \
		--platform linux/$* \
		-t landinjm/prisms-pf-dependencies:alpine-minimal-$* \
		--build-arg NJOBS=${NJOBS} \
		--build-arg ALL_DEPENDENCIES=OFF \
		./dependencies

minimal-dependencies-merge:
	docker buildx imagetools create -t landinjm/prisms-pf-dependencies:alpine-minimal \
		landinjm/prisms-pf-dependencies:alpine-minimal-arm64 \
		landinjm/prisms-pf-dependencies:alpine-minimal-amd64

master-minimal-%:
	$(DOCKER_BUILD) \
		--platform linux/$* \
		-t landinjm/prisms-pf:alpine-master-minimal-$* \
		--build-arg NJOBS=${NJOBS} \
		--build-arg ALL_DEPENDENCIES=OFF \
		--build-arg IMG=alpine-minimal-$* \
		./prisms-pf

master-minimal-merge:
	docker buildx imagetools create -t landinjm/prisms-pf:alpine-master-minimal \
		landinjm/prisms-pf:alpine-master-minimal-arm64 \
		landinjm/prisms-pf:alpine-master-minimal-amd64

minimal-dependencies: minimal-dependencies-amd64 minimal-dependencies-arm64 minimal-dependencies-merge

master-minimal: master-minimal-amd64 master-minimal-arm64 master-minimal-merge

all: minimal-dependencies master-minimal

.PHONY: all \
	minimal-dependencies \
	minimal-dependencies-% \
	minimal-dependencies-merge \
	master-minimal \
	master-minimal-% \
	master-minimal-merge
