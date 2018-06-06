FROM centos:centos6
MAINTAINER Greg Landrum <greg.landrum@t5informatics.com>

# container for building the RDKit python wrappers using anaconda5

RUN yum update -y && yum install -y \
  wget

RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
     wget --quiet https://repo.continuum.io/miniconda/Miniconda3-4.5.1-Linux-x86_64.sh && \
     /bin/bash /Miniconda3-4.5.1-Linux-x86_64.sh -b -p /opt/conda && \
     rm Miniconda3-4.5.1-Linux-x86_64.sh

ENV PATH /opt/conda/bin:$PATH
ENV LANG C

RUN conda update -y -n base conda
RUN conda update -y --all
RUN conda install -y cmake git patch conda-build boost boost-cpp numpy=1.12
RUN conda install -y cmake gxx_linux-64 gcc_linux-64

RUN mkdir /src
WORKDIR /src
ARG RDKIT_BRANCH
RUN git clone https://github.com/rdkit/conda-rdkit.git
WORKDIR /src/conda-rdkit
RUN git checkout development

RUN source activate base && conda build nox
RUN source activate base && conda build cairo_nox
RUN source activate base && CONDA_PY=36 conda build rdkit
RUN source activate base && CONDA_PY=27 conda build rdkit
RUN source activate base && CONDA_PY=35 conda build rdkit
