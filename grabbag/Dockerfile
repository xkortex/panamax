FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04 as base_cudnn

# setup environment
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8


# Bare-bones boilerplate system deps along with some technical libs
# tzdata must be installed with noninteractive in order to prevent interactive prompt
RUN    apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        curl \
        wget \
        apt-transport-https \
        software-properties-common \
        ca-certificates \
        git \
        openssl \
        tzdata \
    && rm -rf /var/lib/apt/lists/* # this is a docker idiom, it helps keep image sizes down

# Need CMake >= 3.11.4 for VIAME,
# Thus, install latest stable CMake 3.14.1

RUN     wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null \
            | apt-key add - \
    &&  apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main' \
    &&  apt-get update -qq \
    &&  apt-get install -qq cmake

# Compilation / CV deps
RUN     add-apt-repository "deb http://security.ubuntu.com/ubuntu xenial-security main" \
    &&  apt-get update -qq \
    &&  apt-get install -y --no-install-recommends \
            build-essential \
            cmake \
            ninja-build \
            gfortran \
            libatlas-base-dev \
            libboost-all-dev \
            libgflags-dev \
            libgoogle-glog-dev \
            libhdf5-serial-dev \
            libleveldb-dev \
            liblmdb-dev \
            libopencv-dev \
            libprotobuf-dev \
            libjpeg-dev \
            libpng-dev \
            libtiff-dev \
            libsnappy-dev \
            libopenblas-base \
            libomp-dev \
            protobuf-compiler \
    && rm -rf /var/lib/apt/lists/*

# creature comforts
RUN      apt-get update -qq \
    &&  apt-get install -y --no-install-recommends \
        zsh \
        wget \
        unzip \
        sudo \
        nano \
        vim \
        iputils-ping \
        iproute2 \
        net-tools \
        dnsutils \
        inetutils-traceroute \
        jq \
        lsb-release \
        zlib1g-dev \
        cmake-curses-gui \
        mc \
        tmux \
    && rm -rf /var/lib/apt/lists/*


# === === === === === === === === === === === === === ===
FROM base_cudnn as conda

WORKDIR /src
# We want to pin to an an exact version of conda, for stability
ENV PATH ${PATH}:/conda/bin
ENV CONDA_VERS=Miniconda3-4.6.14-Linux-x86_64
RUN curl -fsSL -O "https://repo.anaconda.com/miniconda/${CONDA_VERS}.sh" && \
    chmod u+x "${CONDA_VERS}.sh" && \
    "./${CONDA_VERS}.sh" -p /conda -b && \
    rm "./${CONDA_VERS}.sh" &&\
    conda update -y conda

WORKDIR /src

# Doing some unusual stuff to deal with the way conda likes to mangle the shell and env
# `RUN foo` is analogous to `/bin/sh -c foo`, so it uses sh shell, not bash. Each invocation of RUN
# is its own environment, with no memory of past envs.
# First, we have to force docker to use bash instead of sh
# We are going to use the `base` conda env for everything because sourcing conda env in docker is a PAIN
# We use literal paths to /conda/bin/pip and /conda/bin/python because we cannot rely on the env to be set correctly
SHELL ["/bin/bash", "-c"]
RUN     conda init bash


# We shall manually install the most "important" packages in order to constrain our dependencies
# with as few hard constraints as possible, but those are the most "essential" ones
RUN     conda install -c pytorch \
            cudatoolkit=10.0 \
            cudnn \
            pytorch \
            torchvision \
            numpy \
            scipy \
            imageio \
            pillow \
            requests\
            pandas \
            jupyter \
            pip

RUN conda install -c conda-forge opencv~=4.1

# Use a custom entry point so we do not have to deal with manually sourcing conda when bashing in
COPY ./entry.sh /entry.sh
RUN chmod +x /entry.sh
ENTRYPOINT ["/entry.sh"]
CMD bash