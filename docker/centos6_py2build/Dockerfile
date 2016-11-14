FROM centos6_base
MAINTAINER Greg Landrum <greg.landrum@t5informatics.com>

# actually do the conda install
RUN conda install -y nomkl numpy=1.10 pillow cairocffi pandas boost=1.56

RUN mkdir $RDBASE/build
WORKDIR $RDBASE/build
RUN CONDA_PY=27 BOOST_ROOT=/opt/conda cmake -DEIGEN3_INCLUDE_DIR=/opt/conda/include/eigen3 -DPYTHON_EXECUTABLE=/opt/conda/bin/python -DPYTHON_INCLUDE_DIR=/opt/conda/include/python2.7 -DPYTHON_LIBRARY=/opt/conda/lib/libpython2.7.so -DPYTHON_NUMPY_INCLUDE_PATH=/opt/conda/lib/python2.7/site-packages/numpy/core/include -D Boost_NO_SYSTEM_PATHS=ON -D RDK_BUILD_AVALON_SUPPORT=ON -D RDK_BUILD_INCHI_SUPPORT=ON -DRDK_BUILD_THREADSAFE_SSS=on -DRDK_TEST_MULTITHREADED=ON ..
RUN make -j2 install

ENV PYTHONPATH=$RDBASE
RUN ctest -j2 --output-on-failure

WORKDIR $RDBASE
