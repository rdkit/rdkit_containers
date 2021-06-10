FROM centos7_basebuild
LABEL maintainer="Greg Landrum <greg.landrum@t5informatics.com>"

RUN yum update -y 
RUN yum install -y \
  zlib-devel bzip2-devel

# install boost from scratch since we need a -fPIC build. "yay"
WORKDIR /opt
RUN wget -q https://boostorg.jfrog.io/artifactory/main/release/1.73.0/source/boost_1_73_0.tar.bz2 && \
tar xjf boost_1_73_0.tar.bz2

# build boost
WORKDIR /opt/boost_1_73_0

RUN export CFLAGS="-O2 -fPIC" && \
export CXXFLAGS="-std=c++11 ${CFLAGS}"  && \
./bootstrap.sh --prefix="/opt/boost" --with-libraries=system,iostreams,serialization,program_options,regex && \
./b2 link=static install -j2 cxxflags="$CXXFLAGS"


