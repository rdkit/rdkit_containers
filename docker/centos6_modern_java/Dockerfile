FROM centos6_modern
MAINTAINER Greg Landrum <greg.landrum@t5informatics.com>


# the old version of junit.jar that Centos6 has interferes with cmake and I can't figure out how to
# get the VERSIONS argument in find_jar to work. So we just remove the symlink in /usr/share/java
# and everything's fine:
# RUN rm -f /usr/share/java/junit.jar
RUN wget --quiet -O jdk-8-linux-x64.rpm --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.rpm"
RUN LD_LIBRARY_PATH="" yum localinstall -y jdk-8-linux-x64.rpm

RUN conda install -y -c conda-forge swig

ENV LD_LIBRARY_PATH=/lib64:$RDBASE/lib:/opt/boost/lib:/opt/conda/lib
RUN mkdir $RDBASE/build_java
WORKDIR $RDBASE/build_java

# ready to build:
RUN . /opt/rh/devtoolset-6/enable && \
  export CXXFLAGS="-std=c++14 -fPIC"  && \
  JAVA_HOME=/usr/java/latest/ cmake -DEIGEN3_INCLUDE_DIR=/opt/conda/include/eigen3 \
     -D BOOST_ROOT=/opt/boost -D Boost_NO_SYSTEM_PATHS=ON -DBoost_USE_STATIC_LIBS=ON \
     -DRDK_BUILD_AVALON_SUPPORT=ON -DRDK_BUILD_INCHI_SUPPORT=ON -DRDK_BUILD_FREESASA_SUPPORT=ON \
     -DRDK_BUILD_CAIRO_SUPPORT=OFF -DRDK_BUILD_THREADSAFE_SSS=ON -DRDK_TEST_MULTITHREADED=ON \
     -DRDK_BUILD_SWIG_WRAPPERS=ON -DRDK_BUILD_CPP_TESTS=OFF -DRDK_BUILD_PYTHON_WRAPPERS=OFF \
     ..
#
RUN make -j2 install
RUN ctest -j2 --output-on-failure
