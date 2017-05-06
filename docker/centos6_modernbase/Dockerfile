FROM centos:centos6
MAINTAINER Greg Landrum <greg.landrum@t5informatics.com>

RUN yum update -y && yum install -y \
  wget \
  cairo \
  libXext \
  patch

# developer toolset 2.0
RUN wget -O /etc/yum.repos.d/slc6-devtoolset.repo http://linuxsoft.cern.ch/cern/devtoolset/slc6-devtoolset.repo

# install and then edit the activate script to no longer do python
RUN yum install --nogpgcheck -y devtoolset-2

RUN sed 's/pythonvers/#pythonvers/; s/export PYTHONPATH/#export PYTHONPATH/' /opt/rh/devtoolset-2/enable > /opt/rh/devtoolset-2/enable_nopy

# conda
RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
   wget --quiet https://repo.continuum.io/miniconda/Miniconda3-4.3.11-Linux-x86_64.sh && \
   /bin/bash /Miniconda3-4.3.11-Linux-x86_64.sh -b -p /opt/conda && \
   rm Miniconda3-4.3.11-Linux-x86_64.sh

ENV PATH /opt/conda/bin:$PATH
ENV LANG C

# actually do the conda install
RUN conda config --prepend channels  https://conda.anaconda.org/rdkit
RUN conda config --append channels  https://conda.anaconda.org/conda-forge
RUN conda install -y nomkl numpy eigen

RUN yum install -y git

RUN mkdir /src
WORKDIR /src
ENV RDBASE=/src/rdkit
ENV RDKIT_BRANCH=modern_cxx
RUN git clone https://github.com/rdkit/rdkit.git
WORKDIR $RDBASE
RUN git checkout $RDKIT_BRANCH

ENV LD_LIBRARY_PATH=/lib64:$RDBASE/lib:/opt/conda/lib
WORKDIR $RDBASE
