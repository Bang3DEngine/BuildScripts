#!/bin/sh

# Variables
OS_NAME="Linux"
VERSION="0.0"
DOCKER_IMG_NAME="debian:jessie"
BUILD_SRC_DIR="/BangEditor/Build/BuildPackage"
BUILD_SRC_NAME="BangEditor.tar.gz"
BUILD_DST_DIR="/var/www/html/BangBuilds/${OS_NAME}"
BUILD_DST_NAME="BangEditor_${OS_NAME}.tar.gz"

# Make space removing all images and containers
echo "Removing existing containers and images to make some room..."
docker rm  -f $(docker ps -a -q)
docker rmi -f $(docker images -q)

# Build commands
CMD="\
apt-get update &&
apt-get -y install git cmake make gcc g++ autogen libtool automake autoconf libglu1-mesa-dev zlib1g-dev libsndfile1-dev &&
git clone --recurse-submodules --depth=1 https://github.com/Bang3DEngine/BangEditor &&
cd ${BUILD_SRC_DIR} &&
mkdir -p build && cd build &&
cmake -DCMAKE_BUILD_TYPE=Release -DFORCE_NO_PIE=OFF .. &&
make VERBOSE=1 -j6
"

# Run commands in docker
docker run ${DOCKER_IMG_NAME} /bin/bash -c "$CMD"
if [ $? -ne 0 ] ; then echo "ERROR with some docker instruction." ; exit 1 ; fi

# Retrieve the build result
CONT_ID=$(docker ps -q -l)
echo "Retrieving results from $CONT_ID..."

mkdir -p ${BUILD_DST_DIR}
docker cp $CONT_ID:${BUILD_SRC_DIR}/${BUILD_SRC_NAME} ${BUILD_DST_DIR}/${BUILD_DST_NAME}

exit 0
