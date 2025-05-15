ARG IMG=noble
ARG ARCH=amd64

FROM landinjm/prisms-pf-dependencies:${IMG}-${ARCH}

ARG NJOBS=0          # Jobs used for building. Default: Use all available jobs.
ARG VER=master       # PRISMS-PF branch that gets checked out.
ARG FLAGS=""         # Additional flags for the build.

USER root

# Install PRISMS-PF
RUN cd $HOME && \
    git clone https://github.com/prisms-center/phaseField.git && \
    cd phaseField && \
    git checkout $VER && \
    chown -R $USER:$USER . && \
    chmod -R 755 . && \
    cmake . && \
    make -j $NJOBS

USER $USER
WORKDIR $HOME