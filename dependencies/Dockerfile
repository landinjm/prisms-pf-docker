FROM alpine:3.22.1

ARG USER=prisms-pf     # Default user
ARG UID=1233           # Default user ID
ARG NJOBS=0            # Jobs used for building. Default: Use all available jobs.
ARG DEAL_II_VER=v9.6.2 # deal.II branch that gets checked out.
ARG FLAGS=""           # Additional flags for the build.

USER root

# Grab some packages from the package manager
RUN apk update --no-cache && apk add --no-cache \
    bash \
    build-base \
    cmake \
    git \
    gmp-dev \
    ninja \
    python3 \
    py3-pip \
    boost-dev \
    openmpi \
    openmpi-dev \
    lapack-dev \
    blas-dev

# Add MPI to path
ENV PATH="/usr/lib/openmpi/bin:${PATH}"

# Install p4est
RUN wget https://p4est.github.io/release/p4est-2.8.7.tar.gz && \
    wget https://dealii.org/developer/external-libs/p4est-setup.sh && \
    chmod u+x p4est-setup.sh && \
    ./p4est-setup.sh p4est-2.8.7.tar.gz /usr/local/p4est && \
    rm p4est-setup.sh && \
    rm p4est-2.8.7.tar.gz

# Install deal.II
RUN git clone https://github.com/dealii/dealii dealii-$DEAL_II_VER && \
    cd dealii-$DEAL_II_VER && \
    git checkout $DEAL_II_VER && \
    mkdir build && cd build && \
    cmake -GNinja \
    -DCMAKE_CXX_FLAGS="$FLAGS" \
    -DCMAKE_CXX_STANDARD=20 \
    -DCMAKE_C_COMPILER=mpicc \
    -DCMAKE_CXX_COMPILER=mpicxx \
    -DDEAL_II_EARLY_DEPRECATIONS=ON \
    -DDEAL_II_ALLOW_AUTODETECTION=OFF \
    -DDEAL_II_COMPONENT_PYTHON_BINDINGS=OFF \
    -DDEAL_II_WITH_64BIT_INDICES=OFF \
    -DDEAL_II_WITH_ADOLC=OFF \
    -DDEAL_II_WITH_ARBORX=OFF \
    -DDEAL_II_WITH_ARPACK=OFF \
    -DDEAL_II_WITH_ASSIMP=OFF \
    -DDEAL_II_WITH_BOOST=ON \
    -DDEAL_II_WITH_CGAL=OFF \
    -DDEAL_II_WITH_COMPLEX_VALUES=OFF \
    -DDEAL_II_WITH_GINKGO=OFF \
    -DDEAL_II_WITH_GMSH=OFF \
    -DDEAL_II_WITH_GSL=OFF \
    -DDEAL_II_WITH_HDF5=OFF \
    -DDEAL_II_WITH_KOKKOS=ON \
    -DDEAL_II_WITH_LAPACK=ON \
    -DDEAL_II_WITH_METIS=OFF \
    -DDEAL_II_WITH_MPI=ON \
    -DDEAL_II_WITH_MUPARSER=OFF \
    -DDEAL_II_WITH_OPENCASCADE=OFF \
    -DDEAL_II_WITH_P4EST=ON \
    -DDEAL_II_WITH_PETSC=OFF \
    -DDEAL_II_WITH_SCALAPACK=OFF \
    -DDEAL_II_WITH_SLEPC=OFF \
    -DDEAL_II_WITH_SUNDIALS=OFF \
    -DDEAL_II_WITH_SYMENGINE=OFF \
    -DDEAL_II_WITH_TASKFLOW=ON \
    -DDEAL_II_WITH_TBB=OFF \
    -DDEAL_II_WITH_TRILINOS=OFF \
    -DDEAL_II_WITH_UMFPACK=OFF \
    -DDEAL_II_WITH_VTK=OFF \
    -DDEAL_II_WITH_ZLIB=ON \
    -DP4EST_DIR=/usr/local/p4est \
    .. && \
    ninja -j $NJOBS install && \
    cd ../ && rm -rf .git build

# Remove the headers
RUN apk del boost-dev \
    openmpi-dev \
    gmp-dev \
    && rm -rf /var/cache/apk/*

# Add default user
RUN adduser --disabled-password --gecos '' --uid $UID $USER
RUN adduser $USER sudo; echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Set the user and home directory
RUN chown -R $USER:$USER /home/$USER
USER $USER
ENV HOME=/home/$USER
ENV USER=$USER
ENV OMPI_MCA_btl="^vader"
WORKDIR $HOME