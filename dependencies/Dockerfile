ARG IMG=noble

FROM dealii/dependencies:${IMG}

ARG USER=prisms-pf     # Default user
ARG UID=1002          # Default user ID
ARG NJOBS=0            # Jobs used for building. Default: Use all available jobs.
ARG DEAL_II_VER=v9.6.2  # deal.II branch that gets checked out.
ARG FLAGS=""           # Additional flags for the build.

USER root

# Install deal.II
RUN cd /usr/src && \
    git clone https://github.com/dealii/dealii dealii-$DEAL_II_VER && \
    cd dealii-$DEAL_II_VER && \
    git checkout $DEAL_II_VER && \
    mkdir build && cd build && \
    cmake -GNinja \
    -DCMAKE_CXX_FLAGS="$FLAGS" \
    -DCMAKE_CXX_STANDARD=20 \
    -DCMAKE_PREFIX_PATH="/usr/lib/x86_64-linux-gnu/hdf5/openmpi;/usr/include/hdf5/openmpi" \
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
    -DDEAL_II_WITH_GSL=ON \
    -DDEAL_II_WITH_HDF5=ON \
    -DDEAL_II_WITH_KOKKOS=ON \
    -DDEAL_II_WITH_LAPACK=ON \
    -DDEAL_II_WITH_METIS=OFF \
    -DDEAL_II_WITH_MPI=ON \
    -DDEAL_II_WITH_MUPARSER=OFF \
    -DDEAL_II_WITH_OPENCASCADE=OFF \
    -DDEAL_II_WITH_P4EST=ON \
    -DDEAL_II_WITH_PETSC=ON \
    -DDEAL_II_WITH_SCALAPACK=OFF \
    -DDEAL_II_WITH_SLEPC=OFF \
    -DDEAL_II_WITH_SUNDIALS=ON \
    -DDEAL_II_WITH_SYMENGINE=OFF \
    -DDEAL_II_WITH_TASKFLOW=OFF \
    -DDEAL_II_WITH_TBB=ON \
    -DDEAL_II_WITH_TRILINOS=ON \
    -DDEAL_II_WITH_UMFPACK=OFF \
    -DDEAL_II_WITH_VTK=ON \
    -DDEAL_II_WITH_ZLIB=ON \
    .. && \
    ninja -j $NJOBS install && \
    cd ../ && rm -rf .git build

# Install Caliper
RUN cd /usr/src && \
    git clone https://github.com/LLNL/Caliper.git caliper && \
    cd caliper && \
    mkdir build && cd build && \
    cmake -GNinja .. && \
    ninja -j $NJOBS install && \
    cd ../ && rm -rf .git build

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