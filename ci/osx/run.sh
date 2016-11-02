#!/bin/bash
set -e -x
# Init pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

pip install -r requirements-dev.txt
pip wheel . -w wheelhouse/ -v
pip install -I virgil-crypto --no-index -f wheelhouse/
cd wheelhouse/; nosetests virgil_crypto
