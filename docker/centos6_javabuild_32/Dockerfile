FROM centos6_base
MAINTAINER Greg Landrum <greg.landrum@t5informatics.com>

RUN yum install -y \
    pcre-devel

# 32bit libs:
RUN yum groupinstall -y "Compatibility libraries"
RUN yum install -y glibc-devel.i686 libstdc++-devel.i686

# Java 1.8 from oracle
RUN wget --quiet --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u60-b27/jdk-8u60-linux-i586.rpm"
RUN yum localinstall -y jdk-8u60-linux-i586.rpm

RUN cd /tmp && \
   wget -nv --no-check-certificate https://sourceforge.net/projects/swig/files/swig/swig-3.0.7/swig-3.0.7.tar.gz && \
   tar xzf ./swig-3.0.7.tar.gz && \
   cd /tmp/swig-3.0.7 && \
   ./configure && \
   make -j2 && \
   make -j2 install

RUN cd /usr/local/src && \
   wget -nv --no-check-certificate https://downloads.sourceforge.net/project/boost/boost/1.61.0/boost_1_61_0.tar.bz2 && \
   tar xjf ./boost_1_61_0.tar.bz2

RUN cd /usr/local/src/boost_1_61_0 && \
   ./bootstrap.sh --with-libraries=thread,serialization,system,regex --prefix=/opt/boost_1_61_0 && \
   ./b2 cxxflags="-m32 -fPIC" -j2 && \
   ./b2 cxxflags="-m32 -fPIC" -j2 install


RUN mkdir $RDBASE/build_java
WORKDIR $RDBASE/build_java
RUN JAVA_HOME=/usr/java/jdk1.8.0_60 LDFLAGS=-m32 CXXFLAGS=-m32 CFLAGS=-m32 cmake -DJAVA_JVM_LIBRARY=$JAVA_HOME/jre/lib/i386/server/libjvm.so -DEIGEN3_INCLUDE_DIR=/opt/conda/include/eigen3 -D BOOST_ROOT=/opt/boost_1_61_0 -D Boost_NO_SYSTEM_PATHS=ON -D Boost_USE_STATIC_LIBS=ON -D RDK_BUILD_PYTHON_WRAPPERS=OFF -D RDK_BUILD_AVALON_SUPPORT=ON -D RDK_BUILD_INCHI_SUPPORT=ON -DRDK_BUILD_THREADSAFE_SSS=on -DRDK_TEST_MULTITHREADED=ON -DRDK_BUILD_SWIG_WRAPPERS=ON -D RDK_BUILD_CPP_TESTS=OFF .. 
RUN make -j2 install
RUN ctest -j2 --output-on-failure

WORKDIR $RDBASE
