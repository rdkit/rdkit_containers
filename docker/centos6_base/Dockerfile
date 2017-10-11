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
RUN echo "auto_update_conda: False" >> ~/.condarc
RUN conda config --add channels  https://conda.anaconda.org/rdkit
RUN conda install -y nomkl numpy=1.13 boost=1.63
RUN conda install -y conda=4.3.25
RUN conda install -y eigen

RUN mkdir /src
WORKDIR /src
ENV RDBASE=/src/rdkit
ARG RDKIT_BRANCH
RUN git clone https://github.com/rdkit/rdkit.git
WORKDIR $RDBASE
RUN git checkout $RDKIT_BRANCH

ENV LD_LIBRARY_PATH=/lib64:$RDBASE/lib:/opt/conda/lib
WORKDIR $RDBASE
