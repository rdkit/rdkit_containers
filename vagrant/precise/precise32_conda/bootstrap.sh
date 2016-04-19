#!/usr/bin/env bash

apt-get update
apt-get install -y python-software-properties software-properties-common 
apt-get install -y build-essential g++ cmake
add-apt-repository ppa:git-core/ppa
apt-get update
apt-get install -y git-core
   
if [ \! -e /opt/conda ]
then
  echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh
  wget --quiet https://repo.continuum.io/miniconda/Miniconda3-3.19.0-Linux-x86.sh && \
    /bin/bash Miniconda3-3.19.0-Linux-x86.sh -b -p /opt/conda && \
    rm Miniconda3-3.19.0-Linux-x86.sh
fi

export PATH=/opt/conda/bin:$PATH
conda update -y conda python
conda install -y conda-build anaconda-client

if [ \! -e /home/vagrant/conda-rdkit ]
then
    cd /home/vagrant
    git clone https://github.com/rdkit/conda-rdkit.git
    chown -R vagrant /home/vagrant/conda-rdkit
fi

conda config  --add channels https://conda.anaconda.org/rdkit





