#!/usr/bin/env bash
yum install -y  epel-release
yum install -y  wget gcc-c++ git cairo libXext patch pcre pcre-devel

wget 
if [ \! -e /usr/bin/cmake ]
then   
  cd /tmp
  if [ \! -e /tmp/cmake-3.3.2-Linux-x86_64.tar.gz ]
  then
    wget -nv --no-check-certificate https://cmake.org/files/v3.3/cmake-3.3.2-Linux-x86_64.tar.gz
  fi
  tar xzf /tmp/cmake-3.3.2-Linux-x86_64.tar.gz
  cp cmake-3.3.2-Linux-x86_64/bin/* /usr/bin
  cp -r cmake-3.3.2-Linux-x86_64/share/* /usr/share
fi

if [ \! -e /opt/conda ]
then
  echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh
  wget --quiet https://repo.continuum.io/miniconda/Miniconda3-3.19.0-Linux-x86_64.sh && \
    /bin/bash Miniconda3-3.19.0-Linux-x86_64.sh -b -p /opt/conda && \
    rm Miniconda3-3.19.0-Linux-x86_64.sh
fi

export PATH=/opt/conda/bin:$PATH
conda update -y conda python
conda install -y conda-build anaconda-client
conda config --add channels  https://conda.anaconda.org/rdkit
conda install -y boost=1.56

# if [ \! -e /home/vagrant/conda-rdkit ]
# then
#     cd /home/vagrant
#     git clone https://github.com/rdkit/conda-rdkit.git
#     chown -R vagrant conda-rdkit
# fi

conda config  --add channels https://conda.anaconda.org/rdkit


if [ \! -e /usr/local/bin/swig ]
then
  cd /tmp
  if [ \! -e /tmp/swig-3.0.7.tar.gz ]
  then
    wget -nv --no-check-certificate https://sourceforge.net/projects/swig/files/swig/swig-3.0.7/swig-3.0.7.tar.gz
  fi
  tar xzf /tmp/swig-3.0.7.tar.gz
  cd swig-3.0.7
  ./configure
  make -j2 && make -j2 install
fi

if [ \! -e /usr/local/src/boost_1_48_0 ]
then
  cd /usr/local/src
  if [ \! -e /usr/local/src/boost_1_48_0.tar.gz ]
  then
    wget --quiet --no-check-certificate https://sourceforge.net/projects/boost/files/boost/1.48.0/boost_1_48_0.tar.gz
  fi
  tar xzf boost_1_48_0.tar.gz
  cd boost_1_48_0
  CXXFLAGS=-fPIC ./bootstrap.sh --prefix=/usr/local --with-libraries=thread,regex,system,serialization
  ./b2 -j2 cxxflags=-fPIC install 
fi

# eigen3 :
if [ \! -e /opt/eigen3 ]
then
  cd /opt
  wget --quiet -O eigen3.2.10.tar.bz2 http://bitbucket.org/eigen/eigen/get/3.2.10.tar.bz2
  tar xjf eigen3.2.10.tar.bz2
  mv eigen-eigen-* eigen3
  rm eigen3.2.10.tar.bz2
fi

# jdk:
if [ \! -e /opt/jdk1.7.0_79 ]
then
  cd /opt
  if [ \! -e jdk-7u79-linux-x64.tar.gz ]
  then
      wget --quiet -O jdk-7u79-linux-x64.tar.gz --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/7u79-b15/jdk-7u79-linux-x64.tar.gz"

  fi
  tar xzf jdk-7u79-linux-x64.tar.gz
  alternatives --install /usr/bin/java java /opt/jdk1.7.0_79/bin/java 1
  alternatives --install /usr/bin/jar jar /opt/jdk1.7.0_79/bin/jar 1
  alternatives --install /usr/bin/javac javac /opt/jdk1.7.0_79/bin/javac 1
  alternatives --install /usr/bin/javah javah /opt/jdk1.7.0_79/bin/javah 1
  alternatives --install /usr/bin/javadoc javadoc /opt/jdk1.7.0_79/bin/javadoc 1
fi

cd /home/vagrant
export RDKIT_BRANCH=Release_2016_09_1
git clone -b $RDKIT_BRANCH https://github.com/rdkit/rdkit.git
cd rdkit
mkdir build
cd build
JAVA_HOME=/opt/jdk1.7.0_79 BOOST_ROOT=/usr/local cmake -DBoost_USE_STATIC_LIBS=ON -DEIGEN3_INCLUDE_DIR=/opt/eigen3 -DRDK_BUILD_PYTHON_WRAPPERS=OFF -DRDK_BUILD_SWIG_WRAPPERS=ON -DRDK_BUILD_AVALON_SUPPORT=ON -DRDK_BUILD_INCHI_SUPPORT=ON ..
make -j2 install
export RDBASE=/home/vagrant/rdkit
ctest -j2 --output-on-failure && cp $RDBASE/Code/JavaWrappers/gmwrapper/*.{jar,so} /vagrant 



