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
     wget --quiet https://repo.continuum.io/miniconda/Miniconda3-4.3.31-Linux-x86_64.sh && \
     /bin/bash Miniconda3-4.3.31-Linux-x86_64.sh -b -p /opt/conda && \
     rm Miniconda3-4.3.31-Linux-x86_64.sh

ENV PATH /opt/conda/bin:$PATH
ENV LANG C

# # actually do the conda install
RUN echo "auto_update_conda: False" >> ~/.condarc
# RUN conda config --add channels  https://conda.anaconda.org/rdkit
RUN conda install -y conda=4.3.25
RUN conda install -y nomkl numpy=1.13
RUN conda install -y eigen

# install boost from scratch (yay)
WORKDIR /opt
RUN wget --quiet https://sourceforge.net/projects/boost/files/boost/1.63.0/boost_1_63_0.tar.bz2 && \
tar xjf boost_1_63_0.tar.bz2

# disable python in the devtoolset
# RUN sed -i 's/^pythonvers=/#pythonvers=/; s/export PYTHONPATH/#export PYTHONPATH/' /opt/rh/devtoolset-2/enable

# build boost
WORKDIR /opt/boost_1_63_0

RUN export CFLAGS="-O2 -shared" && \
export CXXFLAGS="-std=c++11 ${CFLAGS}"  && \
export BZIP2_INCLUDE="/opt/conda/include" && \
export BZIP2_LIBPATH="/opt/conda/lib" && \
export ZLIB_INCLUDE="/opt/conda/include" && \
export ZLIB_LIBPATH="/opt/conda/lib" && \
./bootstrap.sh --prefix="/opt/boost/"  && \
sed -i 's|using python : 3.6 : /opt/conda ;|using python : 3.6 : /opt/conda/bin/python : /opt/conda/include/python3.6m : /opt/conda/lib ;|' project-config.jam && \
./b2 -q install -j2 cxxflags="$CXXFLAGS"
#
RUN conda install -y --override-channels -c conda-forge bzip2 cmake

# build the RDKit
RUN conda install -y -c rdkit nox && \
  conda install -y cairo pkg-config freetype


RUN mkdir /src
WORKDIR /src
ENV RDBASE=/src/rdkit
RUN git clone https://github.com/rdkit/rdkit.git
WORKDIR $RDBASE
RUN git checkout modern_cxx

# need /opt/conda/lib here because that's where the boost libs are
# put /lib64 at the front to make sure we don't pick up the conda stuff
# by default
ENV LD_LIBRARY_PATH=/lib64:$RDBASE/lib:/opt/conda/lib

WORKDIR $RDBASE
