FROM centos7_base
MAINTAINER Greg Landrum <greg.landrum@t5informatics.com>

RUN mkdir $RDBASE/build
WORKDIR $RDBASE/build
RUN  cmake -D BOOST_ROOT=/opt/conda -D Boost_NO_SYSTEM_PATHS=ON -DEIGEN3_INCLUDE_DIR=/opt/conda/include/eigen3 -D RDK_BUILD_AVALON_SUPPORT=ON -D RDK_BUILD_INCHI_SUPPORT=ON -DRDK_BUILD_THREADSAFE_SSS=on -DRDK_TEST_MULTITHREADED=ON -DRDK_BUILD_PYTHON_WRAPPERS=OFF .. && \
  make -j2 install
RUN ctest -j2 --output-on-failure

WORKDIR $RDBASE
