FROM centos7_basebuild
MAINTAINER Greg Landrum <greg.landrum@t5informatics.com>

# actually do the conda install
RUN conda create -p /opt/conda/envs/py27 -y python=2.7 nomkl numpy=1.10 pillow cairocffi pandas boost=1.56
RUN source activate /opt/conda/envs/py27 && \
    conda install -y -c conda-forge eigen

WORKDIR $RDBASE/build
RUN  CONDA_PY=2.7 cmake -DEIGEN3_INCLUDE_DIR=/opt/conda/envs/py27/include/eigen3 -DPYTHON_EXECUTABLE=/opt/conda/envs/py27/bin/python -DPYTHON_INCLUDE_DIR=/opt/conda/envs/py27/include/python2.7 -DPYTHON_LIBRARY=/opt/conda/envs/py27/lib/libpython2.7.so -DPYTHON_NUMPY_INCLUDE_PATH=/opt/conda/envs/py27/lib/python2.7/site-packages/numpy/core/include -D BOOST_ROOT=/opt/conda/envs/py27 -D Boost_NO_SYSTEM_PATHS=ON -D RDK_BUILD_AVALON_SUPPORT=ON -D RDK_BUILD_INCHI_SUPPORT=ON -DRDK_BUILD_THREADSAFE_SSS=on -DRDK_TEST_MULTITHREADED=ON -DRDK_BUILD_PYTHON_WRAPPERS=ON .. && \
  make -j2 install
ENV PYTHONPATH=$RDBASE
ENV PATH=/opt/conda/envs/py27/bin:$PATH
RUN ctest -j2 --output-on-failure 

WORKDIR $RDBASE
