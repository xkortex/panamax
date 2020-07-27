## Conda with custom entrypoint from base ubuntu image
## Build with e.g. `docker build -t monoconda .`
## Run with `docker run --rm -it monoconda bash` to drop right into
## the environment `foo` !
FROM ubuntu:18.04

## Install things we need to install more things
RUN apt-get update -qq &&\
    apt-get install -qq curl wget git &&\
    apt-get install -qq --no-install-recommends \
        libssl-dev \
        software-properties-common \
    && rm -rf /var/lib/apt/lists/*

## Install miniconda
RUN wget -nv https://repo.anaconda.com/miniconda/Miniconda3-4.7.12-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh

## add conda to the path so we can execute it by name
ENV PATH=/opt/conda/bin:$PATH

## Create /entry.sh which will be our new shell entry point. This performs actions to configure the environment
## before starting a new shell (which inherits the env).
## The exec is important! This allows signals to pass
RUN     (echo '#!/bin/bash' \
    &&   echo '__conda_setup="$(/opt/conda/bin/conda shell.bash hook 2> /dev/null)"' \
    &&   echo 'eval "$__conda_setup"' \
    &&   echo 'conda activate "${CONDA_TARGET_ENV:-base}"' \
    &&   echo '>&2 echo "ENTRYPOINT: CONDA_DEFAULT_ENV=${CONDA_DEFAULT_ENV}"' \
    &&   echo 'exec "$@"'\
        ) >> /entry.sh && chmod +x /entry.sh

## Tell the docker build process to use this for RUN.
## The default shell on Linux is ["/bin/sh", "-c"], and on Windows is ["cmd", "/S", "/C"]
SHELL ["/entry.sh", "/bin/bash", "-c"]
## Now, every following invocation of RUN will start with the entry script
RUN     conda update conda -y

## Create a dummy env
RUN     conda create --name foo

## I added this variable such that I have the entry script activate a specific env
ENV CONDA_TARGET_ENV=foo

## This will get installed in the env foo since it gets activated at the start of the RUN stanza
RUN  conda install pip

## Configure .bashrc to drop into a conda env and immediately activate our TARGET env
RUN conda init && echo 'conda activate "${CONDA_TARGET_ENV:-base}"' >>  ~/.bashrc
ENTRYPOINT ["/entry.sh"]
