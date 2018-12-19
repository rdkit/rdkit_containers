FROM centos:centos6
MAINTAINER Greg Landrum <greg.landrum@t5informatics.com>

RUN yum update -y && yum install -y \
  wget \
  git \
  libXext \
  libXrender-devel \
  patch

# devtoolset (http://linux.web.cern.ch/linux/devtoolset/#dts21)
#RUN wget --quiet -O /etc/yum.repos.d/slc6-devtoolset.repo http://linuxsoft.cern.ch/cern/devtoolset/slc6-devtoolset.repo
#RUN yum install --nogpgcheck -y devtoolset-2
RUN yum install -y centos-release-scl
RUN yum install -y devtoolset-6



# conda.
RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
     wget --quiet https://repo.continuum.io/miniconda/Miniconda3-4.3.21-Linux-x86_64.sh && \
     /bin/bash /Miniconda3-4.3.21-Linux-x86_64.sh -b -p /opt/conda && \
     rm Miniconda3-4.3.21-Linux-x86_64.sh

ENV PATH /opt/conda/bin:$PATH
ENV LANG C


# install boost from scratch (yay)
WORKDIR /opt
RUN wget -q https://dl.bintray.com/boostorg/release/1.65.1/source/boost_1_65_1.tar.bz2 && \
tar xjf boost_1_65_1.tar.bz2

# build boost
WORKDIR /opt/boost_1_65_1

# # actually do the conda install
# RUN echo "auto_update_conda: False" >> ~/.condarc
# RUN conda config --add channels  https://conda.anaconda.org/rdkit
RUN conda install -y nomkl numpy 
RUN conda install -y eigen conda-build anaconda-client
RUN conda install -y conda-forge::cmake
RUN conda install -y -c rdkit nox
RUN conda install -y -c rdkit cairo 

RUN . /opt/rh/devtoolset-6/enable && \
export CFLAGS="-O2 -shared -fPIC" && \
export CXXFLAGS="-std=c++14 ${CFLAGS}"  && \
export BZIP2_INCLUDE="/opt/conda/include" && \
export BZIP2_LIBPATH="/opt/conda/lib" && \
export ZLIB_INCLUDE="/opt/conda/include" && \
export ZLIB_LIBPATH="/opt/conda/lib" && \
./bootstrap.sh --prefix="/opt/boost/"  && \
sed -i 's|using python : 3.6 : /opt/conda ;|using python : 3.6 : /opt/conda/bin/python : /opt/conda/include/python3.6m : /opt/conda/lib ;|' project-config.jam && \
#sed -i 's|return PyUnicode_Check(obj) ? _PyUnicode_AsString(obj) : 0;|return (void *)PyUnicode_Check(obj) ? (void *)_PyUnicode_AsString(obj) : 0;|' libs/python/src/converter/builtin_converters.cpp && \
./b2 -q install -j2 cxxflags="$CXXFLAGS"
#ls
#


# now ready to build the RDKit
