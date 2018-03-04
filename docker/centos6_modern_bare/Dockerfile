FROM centos:centos6
MAINTAINER Greg Landrum <greg.landrum@t5informatics.com>

RUN yum update -y && yum install -y \
  wget \
  git \
  cairo \
  cairo-devel \
  libXext \
  patch

# devtoolset (http://linux.web.cern.ch/linux/devtoolset/#dts21)
#RUN wget --quiet -O /etc/yum.repos.d/slc6-devtoolset.repo http://linuxsoft.cern.ch/cern/devtoolset/slc6-devtoolset.repo
#RUN yum install --nogpgcheck -y devtoolset-2
RUN yum install -y centos-release-scl
RUN yum install -y devtoolset-6



# conda
RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
     wget --quiet https://repo.continuum.io/miniconda/Miniconda3-4.4.10-Linux-x86_64.sh && \
     /bin/bash /Miniconda3-4.4.10-Linux-x86_64.sh -b -p /opt/conda && \
     rm Miniconda3-4.4.10-Linux-x86_64.sh

ENV PATH /opt/conda/bin:$PATH
ENV LANG C


# install boost from scratch (yay)
WORKDIR /opt
RUN wget https://dl.bintray.com/boostorg/release/1.63.0/source/boost_1_63_0.tar.bz2 && \
tar xjf boost_1_63_0.tar.bz2

# build boost
WORKDIR /opt/boost_1_63_0

RUN . /opt/rh/devtoolset-6/enable && \
export CFLAGS="-O2 -shared" && \
export CXXFLAGS="-std=c++14 ${CFLAGS}"  && \
export BZIP2_INCLUDE="/opt/conda/include" && \
export BZIP2_LIBPATH="/opt/conda/lib" && \
export ZLIB_INCLUDE="/opt/conda/include" && \
export ZLIB_LIBPATH="/opt/conda/lib" && \
./bootstrap.sh --prefix="/opt/boost/"  && \
sed -i 's|using python : 3.6 : /opt/conda ;|using python : 3.6 : /opt/conda/bin/python : /opt/conda/include/python3.6m : /opt/conda/lib ;|' project-config.jam && \
./b2 -q install -j2 cxxflags="$CXXFLAGS"
#

# # actually do the conda install
RUN echo "auto_update_conda: False" >> ~/.condarc
# RUN conda config --add channels  https://conda.anaconda.org/rdkit
RUN conda install -y nomkl numpy=1.13
RUN conda install -y eigen conda-build anaconda-client cmake
#RUN conda install -y --override-channels -c conda-forge bzip2 cmake

# now ready to build the RDKit
