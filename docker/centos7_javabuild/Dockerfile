FROM centos7_basebuild
LABEL maintainer="Greg Landrum <greg.landrum@t5informatics.com>"

RUN yum update -y 
RUN yum install -y \
  swig3 \
  java-11-openjdk-devel

WORKDIR $RDBASE/build

# ready to build:
RUN cmake3 -DRDK_BUILD_SWIG_WRAPPERS=ON ..
#
RUN make -j4 install
RUN ctest3 -j4 --output-on-failure -R Java*
WORKDIR $RDBASE
