#!/bin/bash
set -e -x

# Init pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
pip install twine
pyenv rehash

twine upload -r pypitest wheelhouse/* \
      --skip-existing --config-file ./.pypirc \
      -u $PYPI_USERNAME -p $PYPI_PASSWORD
