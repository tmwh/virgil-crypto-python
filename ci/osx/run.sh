#!/bin/bash
set -e -x
# Init pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

for VERSION in $PYTHON_VERSIONS; do
  export PYENV_VERSION=$VERSION

  pip install -r requirements-dev.txt
  pyenv rehash
  pip wheel . -w wheelhouse/ -v
  pip install -I virgil-crypto --no-index -f wheelhouse/
  cd wheelhouse/; nosetests virgil_crypto
  cd ../
done
