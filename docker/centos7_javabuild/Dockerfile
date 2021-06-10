FROM centos7_boostbuild
LABEL maintainer="Greg Landrum <greg.landrum@t5informatics.com>"

RUN yum update -y 
RUN yum install -y \
   swig3 \
  java-1.8.0-openjdk-devel

# ready to build:
RUN mkdir $RDBASE/build_java
WORKDIR $RDBASE/build_java
RUN cmake3 -DRDK_BUILD_SWIG_WRAPPERS=ON -DRDK_BUILD_AVALON_SUPPORT=ON -DRDK_BUILD_INCHI_SUPPORT=ON \
-DRDK_BUILD_THREADSAFE_SSS=ON -DRDK_TEST_MULTITHREADED=ON -DRDK_BUILD_PYTHON_WRAPPERS=OFF \
-DBOOST_ROOT=/opt/boost -DBoost_USE_STATIC_LIBS=ON \
-DBoost_LIBRARY_DIR=/opt/boost/lib -DBoost_INCLUDE_DIR=/opt/boost/include \
-DBoost_NO_BOOST_CMAKE=TRUE -DBoost_NO_SYSTEM_PATHS=ON ..
#
RUN make -j4 BuildJavaWrapperTests && \
  cp ./Code/JavaWrappers/gmwrapper/libGraphMolWrap.so ../Code/JavaWrappers/gmwrapper
RUN ctest3 -j4 --output-on-failure -R Java*
#WORKDIR $RDBASE