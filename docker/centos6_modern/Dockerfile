FROM centos:centos6
MAINTAINER Greg Landrum <greg.landrum@t5informatics.com>

RUN yum update -y && yum install -y \
  wget \
  git \
  cairo \
  libXext \
  patch

# devtoolset (http://linux.web.cern.ch/linux/devtoolset/#dts21)
RUN wget --quiet -O /etc/yum.repos.d/slc6-devtoolset.repo http://linuxsoft.cern.ch/cern/devtoolset/slc6-devtoolset.repo
RUN yum install --nogpgcheck -y devtoolset-2



# conda
RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
     wget --quiet https://repo.continuum.io/miniconda/Miniconda3-4.3.21-Linux-x86_64.sh && \
     /bin/bash /Miniconda3-4.3.21-Linux-x86_64.sh -b -p /opt/conda && \
     rm Miniconda3-4.3.21-Linux-x86_64.sh

ENV PATH /opt/conda/bin:$PATH
ENV LANG C

# # actually do the conda install
RUN echo "auto_update_conda: False" >> ~/.condarc
# RUN conda config --add channels  https://conda.anaconda.org/rdkit
RUN conda install -y conda=4.3.25
RUN conda install -y nomkl numpy=1.13
RUN conda install -y eigen

RUN mkdir /src
WORKDIR /src
ENV RDBASE=/src/rdkit
RUN git clone https://github.com/rdkit/rdkit.git
WORKDIR $RDBASE
RUN git checkout modern_cxx

# install boost from scratch (yay)
WORKDIR /opt
RUN wget https://sourceforge.net/projects/boost/files/boost/1.63.0/boost_1_63_0.tar.bz2 && \
tar xjf boost_1_63_0.tar.bz2

# disable python in the devtoolset
RUN sed -i 's/^pythonvers=/#pythonvers=/; s/export PYTHONPATH/#export PYTHONPATH/' /opt/rh/devtoolset-2/enable

# build boost
WORKDIR /opt/boost_1_63_0

RUN . /opt/rh/devtoolset-2/enable && \
export CFLAGS="-O2 -shared" && \
export CXXFLAGS="-std=c++11 ${CFLAGS}"  && \
export BZIP2_INCLUDE="/opt/conda/include" && \
export BZIP2_LIBPATH="/opt/conda/lib" && \
export ZLIB_INCLUDE="/opt/conda/include" && \
export ZLIB_LIBPATH="/opt/conda/lib" && \
./bootstrap.sh --prefix="/opt/boost/" --with-libraries=python,regex,thread,system,atomic,chrono,date_time,serialization && \
sed -i 's|using python : 3.6 : /opt/conda ;|using python : 3.6 : /opt/conda/bin/python : /opt/conda/include/python3.6m : /opt/conda/lib ;|' project-config.jam && \
./b2 -q install -j2 cxxflags="$CXXFLAGS"

RUN conda install -y --override-channels -c conda-forge bzip2 cmake

# build the RDKit
RUN conda install -y -c rdkit nox && \
  conda install -y cairo pkg-config freetype

ENV LD_LIBRARY_PATH=/lib64:$RDBASE/lib:/opt/boost/lib:/opt/conda/lib
RUN mkdir $RDBASE/build
WORKDIR $RDBASE/build

ENV LD_LIBRARY_PATH=/lib64:$RDBASE/lib:/opt/boost/lib:/opt/conda/lib

# ready to build:
RUN . /opt/rh/devtoolset-2/enable && \
  export CXXFLAGS="-std=c++11"  && \
  JAVA_HOME=/usr/java/latest/ cmake -DRDK_BUILD_PYTHON_WRAPPERS=ON -DEIGEN3_INCLUDE_DIR=/opt/conda/include/eigen3 -D BOOST_ROOT=/opt/boost -D Boost_NO_SYSTEM_PATHS=ON -DRDK_BUILD_AVALON_SUPPORT=ON -DRDK_BUILD_INCHI_SUPPORT=ON -DRDK_BUILD_FREESASA_SUPPORT=ON -DRDK_BUILD_CAIRO_SUPPORT=ON -DRDK_BUILD_THREADSAFE_SSS=on -DRDK_TEST_MULTITHREADED=ON -DRDK_BUILD_SWIG_WRAPPERS=OFF -DRDK_BUILD_CPP_TESTS=ON ..

RUN make -j2 install
ENV PYTHONPATH=$RDBASE
RUN conda install -y pandas pillow
RUN ctest -j2 --output-on-failure



