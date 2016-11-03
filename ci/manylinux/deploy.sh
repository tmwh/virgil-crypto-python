#!/bin/bash
set -e -x

pip install twine --user --ignore-installed

twine upload wheelhouse/* --skip-existing -u $PYPI_USERNAME -p $PYPI_PASSWORD
