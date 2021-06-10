FROM centos6_base
MAINTAINER Greg Landrum <greg.landrum@t5informatics.com>

# actually do the conda install
RUN conda config --add channels  https://conda.anaconda.org/rdkit
RUN conda install -y cairo pkg-config
RUN conda install -y boost=1.56
RUN conda install -y -c conda-forge eigen

RUN mkdir $RDBASE/build
WORKDIR $RDBASE/build
RUN BOOST_ROOT=/opt/conda cmake -D Boost_NO_SYSTEM_PATHS=ON -D RDK_BUILD_AVALON_SUPPORT=ON -D RDK_BUILD_INCHI_SUPPORT=ON -DRDK_BUILD_THREADSAFE_SSS=OFF -DRDK_TEST_MULTITHREADED=OFF -DRDK_BUILD_SWIG_WRAPPERS=OFF -DRDK_BUILD_PYTHON_WRAPPERS=OFF -DRDK_BUILD_CPP_TESTS=OFF -DRDK_USE_BOOST_SERIALIZATION=OFF ..
RUN make -j2 install

WORKDIR $RDBASE
