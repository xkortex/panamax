FROM xkortex/ubuntu:xenial-buildees as base

RUN echo $HOME $USER

RUN     apt-get update -qq \
    &&  apt-get install -qq \
            curl \
            tmux \
            software-properties-common \
    &&  rm -rf /var/lib/apt/lists/*

COPY ./build-tmux.sh ./

RUN bash ./build-tmux.sh
