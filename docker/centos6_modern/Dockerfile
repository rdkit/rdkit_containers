FROM centos6_modern_bare
MAINTAINER Greg Landrum <greg.landrum@t5informatics.com>

# install boost from scratch (yay)
WORKDIR /opt
RUN wget https://dl.bintray.com/boostorg/release/1.63.0/source/boost_1_63_0.tar.bz2 && \
tar xjf boost_1_63_0.tar.bz2

# build boost
WORKDIR /opt/boost_1_63_0

RUN . /opt/rh/devtoolset-6/enable && \
export CFLAGS="-O2 -shared -fPIC" && \
export CXXFLAGS="-std=c++14 ${CFLAGS}"  && \
export BZIP2_INCLUDE="/opt/conda/include" && \
export BZIP2_LIBPATH="/opt/conda/lib" && \
export ZLIB_INCLUDE="/opt/conda/include" && \
export ZLIB_LIBPATH="/opt/conda/lib" && \
./bootstrap.sh --prefix="/opt/boost/"  && \
sed -i 's|using python : 3.6 : /opt/conda ;|using python : 3.6 : /opt/conda/bin/python : /opt/conda/include/python3.6m : /opt/conda/lib ;|' project-config.jam && \
./b2 -q install -j2 cxxflags="$CXXFLAGS"

# complete the conda environment
RUN conda install -y nomkl numpy=1.13 cmake pandas pillow eigen conda-build anaconda-client
#RUN conda install -y -c rdkit nox cairo

RUN mkdir /src
WORKDIR /src
ENV RDBASE=/src/rdkit
RUN git clone https://github.com/rdkit/rdkit.git
WORKDIR $RDBASE
RUN git checkout Release_2018_03

ENV LD_LIBRARY_PATH=/opt/conda/lib:/opt/boost/lib:/lib64:$RDBASE/lib
RUN mkdir $RDBASE/build
WORKDIR $RDBASE/build

# ready to build:
RUN . /opt/rh/devtoolset-6/enable && \
  export CXXFLAGS="-std=c++14 -fPIC"  && \
  cmake -DRDK_BUILD_PYTHON_WRAPPERS=OFF -DEIGEN3_INCLUDE_DIR=/opt/conda/include/eigen3 \
     -D BOOST_ROOT=/opt/boost -D Boost_NO_SYSTEM_PATHS=ON \
     -DRDK_BUILD_AVALON_SUPPORT=ON -DRDK_BUILD_INCHI_SUPPORT=ON -DRDK_BUILD_FREESASA_SUPPORT=ON \
     -DRDK_BUILD_CAIRO_SUPPORT=OFF -DRDK_BUILD_THREADSAFE_SSS=ON -DRDK_TEST_MULTITHREADED=ON \
     -DRDK_BUILD_SWIG_WRAPPERS=OFF -DRDK_BUILD_CPP_TESTS=ON ..
#
RUN make -j2 install
ENV PYTHONPATH=$RDBASE
RUN ctest -j2 --output-on-failure
