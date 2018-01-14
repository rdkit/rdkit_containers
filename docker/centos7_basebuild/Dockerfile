FROM centos7_base
MAINTAINER Greg Landrum <greg.landrum@t5informatics.com>

ENV LD_LIBRARY_PATH=/lib64:$RDBASE/lib:/opt/boost/lib:/opt/conda/lib
RUN mkdir $RDBASE/build
WORKDIR $RDBASE/build

# ready to build:
RUN export CXXFLAGS="-std=c++11"  && \
  cmake -DRDK_BUILD_PYTHON_WRAPPERS=OFF -DEIGEN3_INCLUDE_DIR=/opt/conda/include/eigen3 \
     -D BOOST_ROOT=/opt/boost -D Boost_NO_SYSTEM_PATHS=ON \
     -DRDK_BUILD_AVALON_SUPPORT=ON -DRDK_BUILD_INCHI_SUPPORT=ON -DRDK_BUILD_FREESASA_SUPPORT=ON \
     -DRDK_BUILD_CAIRO_SUPPORT=ON -DRDK_BUILD_THREADSAFE_SSS=on -DRDK_TEST_MULTITHREADED=ON \
     -DRDK_BUILD_SWIG_WRAPPERS=OFF -DRDK_BUILD_CPP_TESTS=ON ..
#
RUN make -j2 install
RUN ctest -j2 --output-on-failure
WORKDIR $RDBASE
