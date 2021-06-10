FROM centos6_modern
MAINTAINER Greg Landrum <greg.landrum@t5informatics.com>


ENV LD_LIBRARY_PATH=/lib64
RUN yum install -y https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-6-x86_64/pgdg-centos96-9.6-3.noarch.rpm && \
    yum install -y postgresql96-server postgresql96-libs postgresql96 postgresql96-devel

RUN service postgresql-9.6 initdb

ENV LD_LIBRARY_PATH=/lib64:$RDBASE/lib:/opt/boost/lib:/opt/conda/lib
RUN mkdir $RDBASE/build_cartridge
WORKDIR $RDBASE/build_cartridge

# ready to build:
RUN . /opt/rh/devtoolset-4/enable && \
  export CXXFLAGS="-std=c++14"  && \
  cmake -DEIGEN3_INCLUDE_DIR=/opt/conda/include/eigen3 \
     -D BOOST_ROOT=/opt/boost -D Boost_NO_SYSTEM_PATHS=ON \
     -DRDK_BUILD_AVALON_SUPPORT=ON -DRDK_BUILD_INCHI_SUPPORT=ON -DRDK_BUILD_FREESASA_SUPPORT=ON \
     -DRDK_BUILD_CAIRO_SUPPORT=ON -DRDK_BUILD_THREADSAFE_SSS=on -DRDK_TEST_MULTITHREADED=ON \
     -DRDK_BUILD_SWIG_WRAPPERS=OFF -DRDK_BUILD_CPP_TESTS=OFF -DRDK_BUILD_PYTHON_WRAPPERS=OFF \
     -DRDK_BUILD_PGSQL=ON \
     ..

RUN make -j2 install && \
    su --login postgres --command "/usr/pgsql-9.6/bin/pg_ctl -D /var/lib/pgsql/9.6/data -l /var/lib/pgsql/9.6/logfile start" && \
    sleep 5s && \
    su --login postgres --command "createuser -w -s root" && \
    sh Code/PgSQL/rdkit/pgsql_install.sh && \
    sh Code/PgSQL/rdkit/pgsql_regress.sh
#
#RUN make -j2 install
#RUN ctest -j2 --output-on-failure
