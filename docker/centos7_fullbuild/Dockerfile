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

# Java 1.8 from oracle
RUN wget --quiet --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u60-b27/jdk-8u60-linux-x64.rpm"
RUN yum localinstall -y jdk-8u60-linux-x64.rpm

# conda
RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-3.19.0-Linux-x86_64.sh && \
    /bin/bash /Miniconda3-3.19.0-Linux-x86_64.sh -b -p /opt/conda && \
    rm Miniconda3-3.19.0-Linux-x86_64.sh

ENV PATH /opt/conda/bin:$PATH
ENV LANG C

# actually do the conda install
RUN conda config --add channels  https://conda.anaconda.org/rdkit
RUN conda install -y nomkl numpy pillow cairocffi pandas boost=1.56


RUN wget -nv --no-check-certificate https://sourceforge.net/projects/swig/files/swig/swig-3.0.7/swig-3.0.7.tar.gz && \
   cd /tmp && \
   tar xzf /swig-3.0.7.tar.gz && \
   cd /tmp/swig-3.0.7 && \
   ./configure && \
   make -j2 && \
   make -j2 install

RUN mkdir /src
WORKDIR /src
ENV RDBASE=/src/rdkit
ENV RDKIT_BRANCH=Release_2016_03_1
RUN git clone -b $RDKIT_BRANCH https://github.com/rdkit/rdkit.git

# need /opt/conda/lib here because that's where the boost libs are
ENV LD_LIBRARY_PATH=$RDBASE/lib:/opt/conda/lib
ENV PYTHONPATH=$RDBASE

RUN mkdir $RDBASE/build
WORKDIR $RDBASE/build
RUN JAVA_HOME=/usr/java/jdk1.8.0_60/ cmake -DPYTHON_EXECUTABLE=/opt/conda/bin/python -DPYTHON_INCLUDE_DIR=/opt/conda/include/python3.5m -DPYTHON_LIBRARY=/opt/conda/lib/libpython3.5m.so -DPYTHON_NUMPY_INCLUDE_PATH=/opt/conda/lib/python3.5/site-packages/numpy/core/include -D BOOST_ROOT=/opt/conda -D Boost_NO_SYSTEM_PATHS=ON -D RDK_BUILD_AVALON_SUPPORT=ON -D RDK_BUILD_INCHI_SUPPORT=ON -DRDK_BUILD_THREADSAFE_SSS=on -DRDK_TEST_MULTITHREADED=ON -DRDK_BUILD_SWIG_WRAPPERS=ON ..
RUN make -j2 install
RUN ctest -j2

WORKDIR $RDBASE
