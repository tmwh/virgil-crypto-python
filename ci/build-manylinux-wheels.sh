#!/bin/bash
set -e -x
shopt -s extglob

# TODO: Create docker image with required utilities
# Install swig using miniconda
wget --quiet https://repo.continuum.io/miniconda/Miniconda2-4.1.11-Linux-x86_64.sh -O ~/miniconda.sh
/bin/bash ~/miniconda.sh -b -p /opt/conda
rm ~/miniconda.sh
export PATH=/opt/conda/bin:$PATH
conda install -y swig
# Install cmake
wget --no-check-certificate https://cmake.org/files/v3.6/cmake-3.6.2-Linux-x86_64.tar.gz
tar xzvf cmake-3.6.2-Linux-x86_64.tar.gz
cp cmake-3.6.2-Linux-x86_64/* /usr/ -rf

# Compile wheels
for PYBIN in /opt/python/!(cp26*)/bin; do
  ${PYBIN}/pip install -r /io/requirements-dev.txt
  ${PYBIN}/pip wheel /io/ -w wheelhouse/
done

# Bundle external shared libraries into the wheels
for whl in wheelhouse/*.whl; do
  auditwheel repair $whl -w /io/wheelhouse/
done

# Install packages and test
for PYBIN in /opt/python/!(cp26*)/bin; do
  ${PYBIN}/pip install -I virgil-crypto --no-index -f /io/wheelhouse
  (cd $HOME; ${PYBIN}/nosetests virgil_crypto)
done
