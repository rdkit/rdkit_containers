FROM ubuntu:xenial
# Does a build ot the RDKit Python wrappers and runs the tests
# Mainly intended as a demo of what's required to do so
MAINTAINER Greg Landrum <greg.landrum@t5informatics.com>

RUN apt-get update && apt-get upgrade && apt install -y \
  curl \
  wget \
  libboost-all-dev \
  cmake \
  git \
  g++ \
  libeigen3-dev \
  python3 \
  libpython3-all-dev \
  python3-numpy \
  python3-pip \
  python3-pil \
  python3-six \
  python3-pandas


ENV LANG C

#
RUN mkdir /src
WORKDIR /src
ENV RDBASE=/src/rdkit
ARG RDKIT_BRANCH
RUN git clone https://github.com/rdkit/rdkit.git
WORKDIR $RDBASE
RUN git checkout $RDKIT_BRANCH

ENV PYTHONPATH=$RDBASE
ENV LD_LIBRARY_PATH=$RDBASE/lib
WORKDIR $RDBASE
RUN mkdir build
WORKDIR build
RUN cmake -DPYTHON_EXECUTABLE=/usr/bin/python3 ..
RUN make -j3 .. install
RUN ctest -j3
