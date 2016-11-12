FROM centos:centos7
MAINTAINER Greg Landrum <greg.landrum@t5informatics.com>

# inspired by https://github.com/InformaticsMatters/rdkit/blob/master/Dockerfile

RUN yum update -y && yum install -y \
  wget \
  gcc-c++ \
  git \
  cairo \
  libXext \
  patch \
  cmake \
  bzip2 \
  pcre-devel 

RUN yum group install -y "Development Tools"

# conda
RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-4.2.12-Linux-x86_64.sh && \
    /bin/bash /Miniconda3-4.2.12-Linux-x86_64.sh -b -p /opt/conda && \
    rm Miniconda3-4.2.12-Linux-x86_64.sh

ENV PATH /opt/conda/bin:$PATH
ENV LANG C

# actually do the conda install
RUN conda config --add channels  https://conda.anaconda.org/rdkit
RUN conda install -y nomkl numpy=1.10 boost=1.56
RUN conda install -y -c conda-forge eigen

RUN mkdir /src
WORKDIR /src
ENV RDBASE=/src/rdkit
ENV RDKIT_BRANCH=Release_2016_09_1
RUN git clone -b $RDKIT_BRANCH https://github.com/rdkit/rdkit.git

# need /opt/conda/lib here because that's where the boost libs are
# put /lib64 at the front to make sure we don't pick up the conda stuff
# by default
ENV LD_LIBRARY_PATH=/lib64:$RDBASE/lib:/opt/conda/lib

WORKDIR $RDBASE
