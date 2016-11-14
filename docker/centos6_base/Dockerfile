FROM centos:centos6
MAINTAINER Greg Landrum <greg.landrum@t5informatics.com>

# inspired by https://github.com/InformaticsMatters/rdkit/blob/master/Dockerfile

RUN yum update -y && yum install -y \
  wget \
  gcc-c++ \
  git \
  cairo \
  libXext \
  patch \
  cmake

# conda
RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda2-4.2.12-Linux-x86_64.sh && \
    /bin/bash /Miniconda2-4.2.12-Linux-x86_64.sh -b -p /opt/conda && \
    rm Miniconda2-4.2.12-Linux-x86_64.sh

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
RUN git clone https://github.com/rdkit/rdkit.git
WORKDIR $RDBASE
RUN git checkout $RDKIT_BRANCH

ENV LD_LIBRARY_PATH=/lib64:$RDBASE/lib:/opt/conda/lib
WORKDIR $RDBASE


