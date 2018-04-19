FROM centos6_modern_bare
MAINTAINER Greg Landrum <greg.landrum@t5informatics.com>

RUN mkdir /src
WORKDIR /src
ENV RDBASE=/src/rdkit
RUN git clone https://github.com/rdkit/rdkit.git
WORKDIR $RDBASE
RUN git checkout master

ENV LD_LIBRARY_PATH=/opt/conda/lib:/opt/boost/lib:/lib64:$RDBASE/lib
RUN mkdir $RDBASE/build
WORKDIR $RDBASE/build

# ready to build:
RUN . /opt/rh/devtoolset-6/enable && \
  export CXXFLAGS="-std=c++14 -fPIC"  && \
  cmake -DRDK_BUILD_PYTHON_WRAPPERS=OFF -DEIGEN3_INCLUDE_DIR=/opt/conda/include/eigen3 \
     -D BOOST_ROOT=/opt/boost -D Boost_NO_SYSTEM_PATHS=ON \
     -DRDK_BUILD_AVALON_SUPPORT=ON -DRDK_BUILD_INCHI_SUPPORT=ON -DRDK_BUILD_FREESASA_SUPPORT=ON \
     -DRDK_BUILD_CAIRO_SUPPORT=ON -DRDK_BUILD_THREADSAFE_SSS=ON -DRDK_TEST_MULTITHREADED=ON \
     -DRDK_BUILD_SWIG_WRAPPERS=OFF -DRDK_BUILD_CPP_TESTS=ON ..
#
#RUN make -j2 install
#ENV PYTHONPATH=$RDBASE
#RUN conda install -y pandas pillow
#RUN ctest -j2 --output-on-failure
