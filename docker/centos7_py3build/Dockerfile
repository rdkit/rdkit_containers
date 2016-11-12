FROM centos7_basebuild
MAINTAINER Greg Landrum <greg.landrum@t5informatics.com>

# actually do the conda install
RUN conda install -y nomkl numpy=1.10 pillow cairocffi pandas boost=1.56

WORKDIR $RDBASE/build
RUN  cmake -DPYTHON_EXECUTABLE=/opt/conda/bin/python -DPYTHON_INCLUDE_DIR=/opt/conda/include/python3.5m -DPYTHON_LIBRARY=/opt/conda/lib/libpython3.5m.so -DPYTHON_NUMPY_INCLUDE_PATH=/opt/conda/lib/python3.5/site-packages/numpy/core/include -D BOOST_ROOT=/opt/conda -D Boost_NO_SYSTEM_PATHS=ON -D RDK_BUILD_AVALON_SUPPORT=ON -D RDK_BUILD_INCHI_SUPPORT=ON -DRDK_BUILD_THREADSAFE_SSS=on -DRDK_TEST_MULTITHREADED=ON -DRDK_BUILD_PYTHON_WRAPPERS=ON .. && \
  make -j2 install
RUN  export PYTHONPATH=$RDBASE && \
  ctest -j2

WORKDIR $RDBASE
