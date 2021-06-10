FROM centos7_base
MAINTAINER Greg Landrum <greg.landrum@t5informatics.com>

# Java 1.8 from oracle
RUN wget --quiet --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u60-b27/jdk-8u60-linux-x64.rpm"
RUN yum localinstall -y jdk-8u60-linux-x64.rpm

RUN cd /tmp && \
   wget -nv --no-check-certificate https://sourceforge.net/projects/swig/files/swig/swig-3.0.7/swig-3.0.7.tar.gz && \
   tar xzf ./swig-3.0.7.tar.gz && \
   cd /tmp/swig-3.0.7 && \
   ./configure && \
   make -j2 && \
   make -j2 install


RUN mkdir $RDBASE/build
WORKDIR $RDBASE/build
RUN JAVA_HOME=/usr/java/jdk1.8.0_60/ cmake -DPYTHON_EXECUTABLE=/opt/conda/bin/python -DPYTHON_INCLUDE_DIR=/opt/conda/include/python3.5m -DPYTHON_LIBRARY=/opt/conda/lib/libpython3.5m.so -DPYTHON_NUMPY_INCLUDE_PATH=/opt/conda/lib/python3.5/site-packages/numpy/core/include -DEIGEN3_INCLUDE_DIR=/opt/conda/include/eigen3 -D BOOST_ROOT=/opt/conda -D Boost_NO_SYSTEM_PATHS=ON -D RDK_BUILD_AVALON_SUPPORT=ON -D RDK_BUILD_INCHI_SUPPORT=ON -DRDK_BUILD_THREADSAFE_SSS=on -DRDK_TEST_MULTITHREADED=ON -DRDK_BUILD_SWIG_WRAPPERS=ON ..
RUN make -j2 install

RUN conda install -y pillow cairocffi pandas
ENV PYTHONPATH=$RDBASE
RUN ctest -j2 --output-on-failure

WORKDIR $RDBASE
