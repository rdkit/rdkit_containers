FROM centos:centos7
MAINTAINER Greg Landrum <greg.landrum@t5informatics.com>

# inspired by https://github.com/InformaticsMatters/rdkit/blob/master/Dockerfile

RUN yum update -y && yum install -y \
  wget \
  gcc-c++ \
  git \
  cairo \
  libXext \
  patch \
  cmake \
  bzip2 \
  java-1.8.0-openjdk-devel \
  sudo \
  pcre-devel 

RUN yum group install -y "Development Tools"

RUN yum install -y postgresql \
  postgresql-devel \
  postgresql-server

# conda
RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-3.19.0-Linux-x86_64.sh && \
    /bin/bash /Miniconda3-3.19.0-Linux-x86_64.sh -b -p /opt/conda && \
    rm Miniconda3-3.19.0-Linux-x86_64.sh

ENV PATH /opt/conda/bin:$PATH
ENV LANG C

# actually do the conda install
RUN conda config --add channels  https://conda.anaconda.org/rdkit
RUN conda install -y nomkl numpy pillow cairocffi pandas boost=1.56


RUN wget -nv --no-check-certificate https://sourceforge.net/projects/swig/files/swig/swig-3.0.7/swig-3.0.7.tar.gz && \
   cd /tmp && \
   tar xzf /swig-3.0.7.tar.gz && \
   cd /tmp/swig-3.0.7 && \
   ./configure && \
   make -j2 && \
   make -j2 install

RUN mkdir /src
WORKDIR /src
ENV RDBASE=/src/rdkit
ENV RDKIT_BRANCH=Release_2016_03_1
RUN git clone -b $RDKIT_BRANCH https://github.com/rdkit/rdkit.git

# need /opt/conda/lib here because that's where the boost libs are
# put /lib64 at the front to make sure we don't pick up the conda stuff
# by default
ENV LD_LIBRARY_PATH=/lib64:$RDBASE/lib:/opt/conda/lib
ENV PYTHONPATH=$RDBASE

# setup postgresql so that we can run the tests
# You wouldn't want to use this setup in production.
RUN sed -i -e "s/Defaults    requiretty.*/ #Defaults    requiretty/g" /etc/sudoers
RUN mkdir /var/psql && \
  chown -R postgres /var/psql && \
  sudo -u postgres initdb /var/psql && \
  sudo -u postgres pg_ctl -w -D /var/psql -l /tmp/psql.logfile start && \
  sudo -u postgres createuser -s root ; sudo -u postgres pg_ctl -D /var/psql stop ; exit 0


RUN mkdir $RDBASE/build
WORKDIR $RDBASE/build
# Build and run all tests except PostgreSQL:
RUN cmake -DPYTHON_EXECUTABLE=/opt/conda/bin/python -DPYTHON_INCLUDE_DIR=/opt/conda/include/python3.5m -DPYTHON_LIBRARY=/opt/conda/lib/libpython3.5m.so -DPYTHON_NUMPY_INCLUDE_PATH=/opt/conda/lib/python3.5/site-packages/numpy/core/include -D BOOST_ROOT=/opt/conda -D Boost_NO_SYSTEM_PATHS=ON -D RDK_BUILD_AVALON_SUPPORT=ON -D RDK_BUILD_INCHI_SUPPORT=ON -DRDK_BUILD_THREADSAFE_SSS=on -DRDK_TEST_MULTITHREADED=ON -DRDK_BUILD_SWIG_WRAPPERS=ON -DRDK_BUILD_PGSQL=ON .. && \
  make -j2 install && \
  ctest -j2 -V -E testPgSQL

# we need to force postgres to start in case we're working from a cache
# setting an environment variable does that:
ENV force_psql_start 1
RUN sudo -u postgres pg_ctl -w -D /var/psql -l /tmp/psql.logfile start && \
  sh /src/rdkit/build/Code/PgSQL/rdkit/pgsql_install.sh && \
  ctest -V -R testPgSQL

WORKDIR $RDBASE
