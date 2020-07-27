ARG BASE_IMAGE=ubuntu:18.04
FROM ${BASE_IMAGE} as base

RUN apt-get update -qq &&\
    apt-get install -qq curl wget git &&\
    apt-get install -qq --no-install-recommends \
        libssl-dev \
        software-properties-common \
    && rm -rf /var/lib/apt/lists/*


RUN wget -nv https://repo.anaconda.com/miniconda/Miniconda3-4.7.12-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh

ENV PATH=/opt/conda/bin:$PATH \
    CONDA_DEFAULT_ENV=base
COPY entry.sh ./
#RUN conda init bash

SHELL ["/entry.sh", "/bin/bash", "-c"]
RUN     conda update conda -y


WORKDIR /app/bar
COPY ./environment.yml /app/bar/

RUN     conda env create -f /app/bar/environment.yml

ENV CONDA_TARGET_ENV=foo

RUN pip install --no-cache-dir six vprint

# Remove conda hooks from ~/.bashrc to let entry.sh work
RUN conda init

RUN echo 'conda activate "${CONDA_TARGET_ENV:-base}"' >>  ~/.bashrc
ENTRYPOINT ["/entry.sh"]
