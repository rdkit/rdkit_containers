FROM centos:centos7
LABEL maintainer="Greg Landrum <greg.landrum@t5informatics.com>"

RUN yum update -y && yum install -y \
  epel-release \
  centos-release-scl \
  wget


RUN yum install -y \
  devtoolset-8 \
  git \
  cairo-devel \
  libXext \
  patch \
  cmake3 \
  bzip2 \
  boost169-devel.x86_64 \
  eigen3-devel  \
  pcre-devel


ENV LANG C


SHELL [ "/usr/bin/scl", "enable", "devtoolset-8"  ]

RUN mkdir /src
WORKDIR /src
ENV RDBASE=/src/rdkit
ARG RDKIT_BRANCH
RUN git clone https://github.com/rdkit/rdkit.git
WORKDIR $RDBASE
RUN git checkout $RDKIT_BRANCH

ENV LD_LIBRARY_PATH=/lib64:$RDBASE/lib
WORKDIR $RDBASE
