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
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-4.4.10-Linux-x86_64.sh && \
    /bin/bash /Miniconda3-4.4.10-Linux-x86_64.sh -b -p /opt/conda && \
    rm Miniconda3-4.4.10-Linux-x86_64.sh

ENV PATH /opt/conda/bin:$PATH
ENV LANG C

# actually do the conda install
#RUN conda config --add channels  https://conda.anaconda.org/rdkit
RUN conda install -y conda-build anaconda-client numpy=1.12
RUN conda install -y eigen

RUN mkdir /src
WORKDIR /src
RUN git clone https://github.com/rdkit/conda-rdkit.git
RUN cd conda-rdkit && git checkout development

WORKDIR /src/conda-rdkit
RUN CONDA_PY=36 conda build boost
RUN CONDA_PY=36 conda build rdkit
RUN CONDA_PY=27 conda build boost
RUN CONDA_PY=27 conda build rdkit
RUN CONDA_PY=35 conda build boost
RUN CONDA_PY=35 conda build rdkit
