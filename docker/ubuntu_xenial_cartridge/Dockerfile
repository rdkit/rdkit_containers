FROM ubuntu:xenial
# Does a build ot the RDKit PostgreSQL cartridge
# Mainly intended as a demo of what's required to do so
MAINTAINER Greg Landrum <greg.landrum@t5informatics.com>

ENV DEBIAN_FRONTEND=noninteractive 
RUN apt-get update && apt-get upgrade -y && apt install -y \
  curl \
  wget \
  libboost-all-dev \
  cmake \
  git \
  g++ \
  zlib1g-dev \
  libeigen3-dev

ENV LANG C

# install postgresql-11 from their repo:
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main" >> /etc/apt/sources.list.d/pgdg.list
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update && apt install -y \
  postgresql-11 \
  postgresql-client-11 \
  postgresql-server-dev-11	

USER postgres
RUN service postgresql start &&\ 
  createuser -s root
USER root


#
RUN mkdir /src
WORKDIR /src
ENV RDBASE=/src/rdkit
# If you want the current production branch use: Release_2020_03
ARG RDKIT_BRANCH
RUN git clone https://github.com/rdkit/rdkit.git
WORKDIR $RDBASE
RUN git checkout $RDKIT_BRANCH

WORKDIR $RDBASE
RUN mkdir build
WORKDIR build
RUN cmake -DRDK_BUILD_PYTHON_WRAPPERS=OFF -DRDK_BUILD_CPP_TESTS=OFF -DRDK_BUILD_INCHI_SUPPORT=ON \
-DRDK_BUILD_AVALON_SUPPORT=ON -D RDK_BUILD_PGSQL=ON -D RDK_USE_URF=OFF -DBoost_USE_STATIC_LIBS=ON \
-DPostgreSQL_CONFIG=/usr/bin/pg_config -DPostgreSQL_TYPE_INCLUDE_DIR=/usr/include/postgresql \
-DPostgreSQL_INCLUDE_DIR=/usr/include/postgresql/11/server ..

# just build the cartridge:
RUN make -j3 rdkit

# install and test it:
RUN sh ./Code/PgSQL/rdkit/pgsql_install.sh &&\
service postgresql restart &&\
sh ./Code/PgSQL/rdkit/pgsql_regress.sh 

