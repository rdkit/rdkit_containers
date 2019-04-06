FROM centos:centos7
MAINTAINER Greg Landrum <greg.landrum@t5informatics.com>

RUN yum update -y && yum install -y \
  epel-release \
  centos-release-scl \
  wget


RUN yum install -y \
  devtoolset-7 \
  python36 \
  python36-devel \
  python36-numpy \
  git \
  cairo-devel \
  libXext \
  patch \
  cmake \
  bzip2 \
  pcre-devel

# RUN yum group install -y "Development Tools"



# RUN yum install -y \
#   python3.6 \
#   gcc-c++ \
#   git \
#   cairo \
#   libXext \
#   patch \
#   cmake \
#   bzip2 \
#   pcre-devel

# RUN yum group install -y "Development Tools"

ENV LANG C


SHELL [ "/usr/bin/scl", "enable", "devtoolset-7"  ]

# # install boost from scratch (yay)
# WORKDIR /opt
# RUN wget --quiet https://sourceforge.net/projects/boost/files/boost/1.67.0/boost_1_67_0.tar.bz2 && \
# tar xjf boost_1_67_0.tar.bz2

# # disable python in the devtoolset
# # RUN sed -i 's/^pythonvers=/#pythonvers=/; s/export PYTHONPATH/#export PYTHONPATH/' /opt/rh/devtoolset-2/enable

# # build boost
# WORKDIR /opt/boost_1_67_0

# RUN export CFLAGS="-O2 -shared" && \
# export CXXFLAGS="-std=c++11 ${CFLAGS}"  && \
# ./bootstrap.sh --prefix="/opt/boost/"  --with-libraries=iostreams,regex,serialization,system && \
# ./b2 -q install -j2 cxxflags="$CXXFLAGS"
# #

# #cmake 
# WORKDIR /opt
# RUN wget --quiet https://cmake.org/files/v3.12/cmake-3.12.3.tar.gz
# RUN tar zxf cmake-3.* && cd cmake-3.* && ./bootstrap --prefix=/opt && make -j2 && make install
# ENV PATH=/opt/bin:$PATH


# RUN mkdir /src
# WORKDIR /src
# ENV RDBASE=/src/rdkit
# RUN git clone https://github.com/rdkit/rdkit.git
# WORKDIR $RDBASE
# ARG BRANCH=master
# RUN git fetch && git checkout $BRANCH

# ENV LD_LIBRARY_PATH=$RDBASE/lib:/opt/boost/lib

# WORKDIR $RDBASE
