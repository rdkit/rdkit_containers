FROM centos6_modern
MAINTAINER Greg Landrum <greg.landrum@t5informatics.com>


# the old version of junit.jar that Centos6 has interferes with cmake and I can't figure out how to
# get the VERSIONS argument in find_jar to work. So we just remove the symlink in /usr/share/java
# and everything's fine:
# RUN rm -f /usr/share/java/junit.jar

RUN conda install -y -c conda-forge swig

ENV LD_LIBRARY_PATH=/lib64:$RDBASE/lib:/opt/boost/lib:/opt/conda/lib
RUN mkdir $RDBASE/build_java
WORKDIR $RDBASE/build_java

# ready to build:
RUN . /opt/rh/devtoolset-4/enable && \
  export CXXFLAGS="-std=c++14"  && \
  cmake -DEIGEN3_INCLUDE_DIR=/opt/conda/include/eigen3 \
     -D BOOST_ROOT=/opt/boost -D Boost_NO_SYSTEM_PATHS=ON \
     -DRDK_BUILD_AVALON_SUPPORT=ON -DRDK_BUILD_INCHI_SUPPORT=ON -DRDK_BUILD_FREESASA_SUPPORT=ON \
     -DRDK_BUILD_CAIRO_SUPPORT=ON -DRDK_BUILD_THREADSAFE_SSS=on -DRDK_TEST_MULTITHREADED=ON \
     -DRDK_BUILD_SWIG_WRAPPERS=ON -DRDK_BUILD_CPP_TESTS=OFF -DRDK_BUILD_PYTHON_WRAPPERS=OFF \
     ..
#
RUN make -j2 install
RUN ctest -j2 --output-on-failure
