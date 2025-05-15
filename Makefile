ARCH=$(shell uname -m)
ifeq ($(ARCH),arm64)
PLATFORM=linux/arm64
else ifeq ($(ARCH),x86_64)
PLATFORM=linux/amd64
ARCH=amd64
endif

DOCKER_BUILD=docker buildx build --push --platform $(PLATFORM) --output type=registry

dependencies-jammy:
	$(DOCKER_BUILD) \
		-t landinjm/prisms-pf-dependencies:jammy-${ARCH} \
		--build-arg IMG=jammy \
		--build-arg NJOBS=8 \
        ./dependencies

dependencies-noble:
	$(DOCKER_BUILD) \
		-t landinjm/prisms-pf-dependencies:noble-${ARCH} \
		--build-arg IMG=noble \
		--build-arg NJOBS=8 \
		./dependencies

dependencies-%-merge::
	docker buildx imagetools create -t landinjm/prisms-pf-dependencies:$* \
		landinjm/prisms-pf-dependencies:$*-arm64 \
		landinjm/prisms-pf-dependencies:$*-amd64

%-merge::
	docker buildx imagetools create -t landinjm/prisms-pf:$* \
		landinjm/prisms-pf:$*-arm64 \
		landinjm/prisms-pf:$*-amd64

devel-noble:
	$(DOCKER_BUILD) \
		-t landinjm/prisms-pf:devel-noble-${ARCH} \
		--build-arg IMG=noble \
		--build-arg ARCH=${ARCH} \
		--build-arg VER=devel \
		--build-arg NJOBS=8 \
		./prisms-pf

devel-jammy:
	$(DOCKER_BUILD) \
		-t landinjm/prisms-pf:devel-jammy-${ARCH} \
		--build-arg IMG=jammy \
		--build-arg ARCH=${ARCH} \
		--build-arg VER=devel \
		--build-arg NJOBS=8 \
		./prisms-pf

noble: dependencies-noble devel-noble 

jammy: dependencies-jammy devel-jammy

all: noble jammy

.PHONY: all \
	dependencies-jammy \
	dependencies-noble \
	dependencies-%-merge \
	%-merge \
	devel-jammy \
	devel-noble