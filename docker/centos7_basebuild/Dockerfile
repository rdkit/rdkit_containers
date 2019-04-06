FROM centos7_base
MAINTAINER Greg Landrum <greg.landrum@t5informatics.com>


ENV LANG C

# install boost from scratch (yay)
WORKDIR /opt
RUN wget --quiet https://dl.bintray.com/boostorg/release/1.69.0/source/boost_1_69_0.tar.bz2 && \
tar xjf boost_1_69_0.tar.bz2

# # disable python in the devtoolset
# # RUN sed -i 's/^pythonvers=/#pythonvers=/; s/export PYTHONPATH/#export PYTHONPATH/' /opt/rh/devtoolset-2/enable

# # build boost
WORKDIR /opt/boost_1_69_0

RUN export CFLAGS="-O2 -shared" && \
export CXXFLAGS="-std=c++11 ${CFLAGS}"  && \
./bootstrap.sh --prefix="/opt/boost/"  --with-libraries=iostreams,regex,serialization,system && \
./b2 -q install -j2 cxxflags="$CXXFLAGS"
# #

# #cmake 
WORKDIR /opt
RUN wget --quiet https://cmake.org/files/v3.12/cmake-3.12.3.tar.gz
RUN tar zxf cmake-3.* && cd cmake-3.* && ./bootstrap --prefix=/opt && make -j2 && make install
ENV PATH=/opt/bin:$PATH


RUN mkdir /src
WORKDIR /src
ENV RDBASE=/src/rdkit
RUN git clone https://github.com/rdkit/rdkit.git
WORKDIR $RDBASE
ARG BRANCH=master
RUN git fetch && git checkout $BRANCH


ENV LD_LIBRARY_PATH=/lib64:$RDBASE/lib:/opt/boost/lib:/opt/conda/lib
RUN mkdir $RDBASE/build
WORKDIR $RDBASE/build

# ready to build:
RUN export CXXFLAGS="-std=c++11"  && \
  cmake -DRDK_BUILD_PYTHON_WRAPPERS=OFF \
     -D BOOST_ROOT=/opt/boost -D Boost_NO_SYSTEM_PATHS=ON \
     -DRDK_BUILD_AVALON_SUPPORT=ON -DRDK_BUILD_INCHI_SUPPORT=ON -DRDK_BUILD_FREESASA_SUPPORT=ON \
     -DRDK_BUILD_CAIRO_SUPPORT=ON -DRDK_BUILD_THREADSAFE_SSS=on -DRDK_TEST_MULTITHREADED=ON \
     -DRDK_BUILD_SWIG_WRAPPERS=OFF -DRDK_BUILD_CPP_TESTS=ON ..
#
RUN make -j2 install
RUN ctest -j2 --output-on-failure
WORKDIR $RDBASE
