#!/bin/bash

set -e -x

# Install build tools
brew update || brew update
brew outdated openssl || brew upgrade openssl
brew outdated cmake || brew upgrade cmake
brew install swig

# install pyenv
git clone --depth 1 https://github.com/yyuu/pyenv.git ~/.pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

pyenv install $PYENV_VERSION
pyenv global $PYENV_VERSION
pyenv rehash
eval "$(pyenv init -)"
pip install --upgrade pip
pip install wheel
