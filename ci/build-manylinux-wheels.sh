#!/bin/bash
set -e -x
shopt -s extglob

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
