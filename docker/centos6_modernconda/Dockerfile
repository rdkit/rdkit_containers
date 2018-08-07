FROM centos6_modern_bare
MAINTAINER Greg Landrum <greg.landrum@t5informatics.com>

# actually do the conda install
RUN conda install -y conda-build anaconda-client

RUN mkdir /src
WORKDIR /src
RUN git clone https://github.com/rdkit/conda-rdkit.git
RUN cd conda-rdkit && git checkout development

WORKDIR /src/conda-rdkit
RUN CONDA_PY=36 conda build rdkit
RUN CONDA_PY=27 conda build rdkit
RUN CONDA_PY=35 conda build rdkit
