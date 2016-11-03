#!/bin/bash

# Build source package
if [ ! -z "$BUILD_SOURCE_PACKAGE" ]; then
  python setup.py sdist -d wheelhouse/
fi

# Build wheels
docker run --rm -v `pwd`:/io $DOCKER_IMAGE $PRE_CMD /io/ci/manylinux/build-wheels.sh
