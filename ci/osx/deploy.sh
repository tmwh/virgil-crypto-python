#!/bin/bash
set -e -x

# Init pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
pip install twine
pyenv rehash

twine upload wheelhouse/* --skip-existing -u $PYPI_USERNAME -p $PYPI_PASSWORD
