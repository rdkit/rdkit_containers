FROM continuumio/miniconda3
MAINTAINER Greg Landrum <greg.landrum@gmail.com>

ENV PATH /opt/conda/bin:$PATH
ENV LANG C

# install the RDKit:
RUN conda config --add channels  https://conda.anaconda.org/rdkit
# note including jupyter in this brings in rather a lot of extra stuff
RUN conda install -y nomkl rdkit pandas cairo jupyter

RUN apt-get update && apt-get install -y libxrender-dev
RUN mkdir /my_data

EXPOSE 8888

CMD jupyter notebook --notebook-dir=/tmp --ip='0.0.0.0' --allow-root
