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


ENV LANG C


SHELL [ "/usr/bin/scl", "enable", "devtoolset-7"  ]

