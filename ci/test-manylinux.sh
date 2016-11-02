#!/bin/bash
docker run --rm -v `pwd`:/io $DOCKER_IMAGE $PRE_CMD /io/travis/build-manylinux-wheels.sh
