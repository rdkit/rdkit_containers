FROM centos:centos6
MAINTAINER Greg Landrum <greg.landrum@t5informatics.com>

RUN yum update -y && yum install -y \
  wget \
  git \
  libXext \
  libXrender-devel \
  patch

RUN yum install -y centos-release-scl
RUN yum install -y devtoolset-6

# conda.
RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
     wget --quiet https://repo.continuum.io/miniconda/Miniconda3-4.5.4-Linux-x86_64.sh && \
     /bin/bash /Miniconda3-4.5.4-Linux-x86_64.sh -b -p /opt/conda && \
     rm Miniconda3-4.5.4-Linux-x86_64.sh

ENV PATH /opt/conda/bin:$PATH
ENV LANG C

# now ready to build the RDKit
