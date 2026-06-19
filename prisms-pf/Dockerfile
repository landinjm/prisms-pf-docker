ARG IMG=alpine-minimal
FROM landinjm/prisms-pf-dependencies:$IMG

ARG NJOBS=0      # Jobs used for building. Default: Use all available jobs.
ARG VER=master   # PRISMS-PF branch that gets checked out.
ARG FLAGS=""     # Additional flags for the build.

USER root

# Install PRISMS-PF & some text editors in one layer
RUN apk add --no-cache \
      vim \
      nano \
    && \
    # Install PRISMS-PF
    git clone --depth=1 -b $VER https://github.com/prisms-center/phaseField.git prisms-pf-$VER && \
    cd prisms-pf-$VER && \
    cmake -B build -G Ninja \
      -DPRISMS_PF_AUTODETECTION=OFF \
      -DPRISMS_PF_EXAMPLES=OFF \
      -DPRISMS_PF_64BIT_INDICES=OFF \
      -DPRISMS_PF_ADDITIONAL_DEGREES=OFF \
      -DPRISMS_PF_WITH_VTK=${ALL_DEPENDENCIES} \
      -DPRISMS_PF_WITH_HDF5=${ALL_DEPENDENCIES} \
      -DPRISMS_PF_WITH_CALIPER=${ALL_DEPENDENCIES} \
      && \
    cmake --build build -j $NJOBS && \
    cmake --install build && \
    cd .. && \
    rm -rf prisms-pf-$VER && \
    rm -rf /var/cache/apk/* /tmp/* /root/.cache

# Set the user and home directory
USER $USER
WORKDIR $HOME
