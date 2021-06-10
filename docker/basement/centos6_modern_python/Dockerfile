FROM centos6_modern
MAINTAINER Greg Landrum <greg.landrum@t5informatics.com>

RUN conda install -y pandas pillow

ENV LD_LIBRARY_PATH=/lib64:$RDBASE/lib:/opt/boost/lib:/opt/conda/lib
RUN mkdir $RDBASE/build_py
WORKDIR $RDBASE/build_py

# ready to build:
RUN . /opt/rh/devtoolset-6/enable && \
  export CXXFLAGS="-std=c++14"  && \
  cmake -DEIGEN3_INCLUDE_DIR=/opt/conda/include/eigen3 \
     -D BOOST_ROOT=/opt/boost -D Boost_NO_SYSTEM_PATHS=ON \
     -DRDK_BUILD_AVALON_SUPPORT=ON -DRDK_BUILD_INCHI_SUPPORT=ON -DRDK_BUILD_FREESASA_SUPPORT=ON \
     -DRDK_BUILD_CAIRO_SUPPORT=ON -DRDK_BUILD_THREADSAFE_SSS=ON -DRDK_TEST_MULTITHREADED=ON \
     -DRDK_BUILD_SWIG_WRAPPERS=OFF -DRDK_BUILD_CPP_TESTS=OFF -DRDK_BUILD_PYTHON_WRAPPERS=ON \
     -DRDK_INSTALL_STATIC_LIBS=OFF \
     ..

ENV PYTHONPATH=$RDBASE
RUN make -j2 install
#RUN ctest -j2 --output-on-failure
