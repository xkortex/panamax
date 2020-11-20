FROM debian:9

ENV DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NONINTERACTIVE_SEEN=true \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8


# get dependencies, build, and remove anything we don't need for running jq.
# valgrind seems to have trouble with pthreads TLS so it's off.

RUN apt-get update && \
    apt-get install -y \
        build-essential \
        autoconf \
        libtool \
        git \
        bison \
        flex \
        python3 \
        python3-pip \
        wget && \
    rm -rf /var/lib/apt/lists/* /var/lib/gems

RUN git clone https://github.com/stedolan/jq.git /app
WORKDIR /app


RUN    pip3 install pipenv && \
        cd /app/docs && pipenv sync

RUN     git submodule init && \
        git submodule update && \
        autoreconf -i && \
        ./configure --disable-valgrind --enable-all-static --prefix=/usr/local

RUN     make -j8 LDFLAGS=-all-static && \
        make check && \
        make install

ENTRYPOINT ["/bin/bash", "-c"]
CMD ["bash"]