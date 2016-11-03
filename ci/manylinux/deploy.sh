#!/bin/bash
set -e -x

pip install twine

twine upload -r pypitest wheelhouse/* \
      --skip-existing --config-file ./.pypirc \
      -u $PYPI_USERNAME -p $PYPI_PASSWORD
