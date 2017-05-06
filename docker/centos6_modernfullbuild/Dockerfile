FROM centos6_modernbase
MAINTAINER Greg Landrum <greg.landrum@t5informatics.com>

RUN yum install -y \
    pcre-devel

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


RUN cd /usr/local/src && \
   wget -nv --no-check-certificate https://downloads.sourceforge.net/project/boost/boost/1.61.0/boost_1_61_0.tar.bz2 && \
   tar xjf ./boost_1_61_0.tar.bz2

# activate the dev toolset code
#RUN . /opt/rh/devtoolset-2/enable
#RUN echo "source /opt/rh/devtoolset-2/enable_nopy" >> /etc/bash.bashrc
#SHELL ["/bin/bash", "--login", "-c"]

RUN . /opt/rh/devtoolset-2/enable_nopy && \
    cd /usr/local/src/boost_1_61_0 && \
    ./bootstrap.sh --with-libraries=thread,serialization,system,regex,python --prefix=/opt/boost_1_61_0 && \
    echo "using python" >> /root/user-config.jam && \
    echo "     : 3.6" >> /root/user-config.jam && \
    echo "     : /opt/conda" >> /root/user-config.jam && \
    echo "     : /opt/conda/include/python3.6m" >> /root/user-config.jam && \
    echo "     : /opt/conda/lib" >> /root/user-config.jam && \
    echo "     ;" >> /root/user-config.jam


RUN . /opt/rh/devtoolset-2/enable_nopy && \
    cd /usr/local/src/boost_1_61_0 && \
   ./b2 cxxflags="-fPIC -std=c++11" -j2 && \
   ./b2 cxxflags="-fPIC -std=c++11" -j2 install

RUN conda install -y cmake

RUN mkdir $RDBASE/build
WORKDIR $RDBASE/build
RUN . /opt/rh/devtoolset-2/enable_nopy && \
    JAVA_HOME=/usr/java/jdk1.8.0_60/ cmake -DPYTHON_EXECUTABLE=/opt/conda/bin/python -DPYTHON_INCLUDE_DIR=/opt/conda/include/python3.6m -DPYTHON_LIBRARY=/opt/conda/lib/libpython3.6m.so -DPYTHON_NUMPY_INCLUDE_PATH=/opt/conda/lib/python3.6/site-packages/numpy/core/include -DEIGEN3_INCLUDE_DIR=/opt/conda/include/eigen3 -D BOOST_ROOT=/opt/boost_1_61_0 -D Boost_NO_SYSTEM_PATHS=ON -D RDK_BUILD_AVALON_SUPPORT=ON -D RDK_BUILD_INCHI_SUPPORT=ON -DRDK_BUILD_THREADSAFE_SSS=on -DRDK_TEST_MULTITHREADED=ON -DRDK_BUILD_SWIG_WRAPPERS=OFF -DCMAKE_CXX_FLAGS=-std=c++11 ..

RUN . /opt/rh/devtoolset-2/enable_nopy && \
    make -j2 install

RUN conda update -y conda python
RUN conda install -y pillow cairocffi pandas
ENV PYTHONPATH=$RDBASE
ENV LD_LIBRARY_PATH=/src/rdkit/lib:/opt/boost_1_61_0/lib:/opt/conda/lib:/lib64

RUN . /opt/rh/devtoolset-2/enable_nopy && \
    ctest -j2 --output-on-failure

WORKDIR $RDBASE
