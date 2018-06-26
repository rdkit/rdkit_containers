# Docker setup for running pre-built RDKit installs

- base: continuumio/miniconda3
- python 3
- latest RDKit release
- python packages installed: rdkit pandas cairo cairocffi jupyter (and all dependencies)

If you build this with the image tag `run_rdkit_conda` like this:

`docker build -t run_rdkit_conda .`

you can run an interactive ipython shell directly like this:

`docker run -i -t run_rdkit_conda ipython`

or you can start a jupyter server like this:

`docker run -d -p 8888 -t run_rdkit_conda jupyter notebook --notebook-dir=/tmp --ip="*"`

You'll need to figure out the appropriate IP address to connect to in order to use this server, or you can do it all as a one liner like this, which will also open a browser for you:

```
  CID=$(docker run -d -p 8888 -t run_rdkit_conda jupyter notebook --notebook-dir=/tmp --ip="*"); B=`docker inspect $CID | grep -w IPAddress | head -1 | cut -f4 -d\"`; open http://$B:8888/tree
```

it make take a few seconds (and require a refresh) for the server to finish starting up so that you can see anything in the browser.

### Additional instructions

For a detailed walkthrough with additional information, visit [this github repository](https://github.com/simonkeng/rdkit-jupyter-docker).
