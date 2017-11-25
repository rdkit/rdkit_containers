FROM centos6_base
MAINTAINER Greg Landrum <greg.landrum@t5informatics.com>

# Install Java.
RUN wget --quiet -O jdk-8-linux-x64.rpm --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.rpm"
RUN yum localinstall -y jdk-8-linux-x64.rpm

# do the conda install
RUN conda install -y nox
RUN conda install -y swig cairo pkg-config freetype
RUN conda install -y --override-channels -c conda-forge bzip2 cmake
RUN conda uninstall -y boost

# install boost from scratch (yay)
WORKDIR /opt
RUN wget --quiet https://sourceforge.net/projects/boost/files/boost/1.63.0/boost_1_63_0.tar.bz2 && \
tar xjf boost_1_63_0.tar.bz2

WORKDIR /opt/boost_1_63_0

RUN export CFLAGS="-O2 -fPIC -shared" && \
export CXXFLAGS="${CFLAGS}"  && \
export BZIP2_INCLUDE="/opt/conda/include" && \
export BZIP2_LIBPATH="/opt/conda/lib" && \
export ZLIB_INCLUDE="/opt/conda/include" && \
export ZLIB_LIBPATH="/opt/conda/lib" && \
./bootstrap.sh --prefix="/opt/boost/" --with-libraries=regex,thread,system,atomic,chrono,date_time,serialization && \
./b2 -q install -j2 --with-regex --with-serialization --with-thread --with-system --with-atomic --with-chrono --with-date_time cxxflags="$CXXFLAGS"

RUN mkdir $RDBASE/build
WORKDIR $RDBASE/build
RUN JAVA_HOME=/usr/java/latest/ cmake -DRDK_BUILD_PYTHON_WRAPPERS=OFF -DEIGEN3_INCLUDE_DIR=/opt/conda/include/eigen3 -D BOOST_ROOT=/opt/boost -D Boost_NO_SYSTEM_PATHS=ON -DBoost_USE_STATIC_LIBS=ON -DRDK_BUILD_AVALON_SUPPORT=ON -DRDK_BUILD_INCHI_SUPPORT=ON -DRDK_BUILD_FREESASA_SUPPORT=ON -DRDK_BUILD_CAIRO_SUPPORT=ON -DRDK_BUILD_THREADSAFE_SSS=on -DRDK_TEST_MULTITHREADED=ON -DRDK_BUILD_SWIG_WRAPPERS=ON -DRDK_BUILD_CPP_TESTS=OFF ..
RUN make -j2 install
RUN ctest -j2 --output-on-failure
WORKDIR $RDBASE

