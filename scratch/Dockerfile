FROM ubuntu:18.04 as ubuntu_base

ARG DEBIAN_FRONTEND=noninteractive

# todo: minimize this even more
RUN apt-get update -qq && apt-get install -qq curl \
    && apt-get install -qq --no-install-recommends \
        cmake \
        libc++abi-dev libopenblas-dev liblapack-dev \
        pkg-config libavcodec-dev libavformat-dev libswscale-dev \
        libtbb2 libtbb-dev libjpeg-dev \
        libpng-dev libtiff-dev \
        libboost-all-dev  && \
    rm -rf /var/lib/apt/lists/*

# Tip: Install pip with get-pip is official preffered method
RUN curl --silent --show-error \
    https://bootstrap.pypa.io/get-pip.py | python2 &&\
    pip2 install numpy==1.16