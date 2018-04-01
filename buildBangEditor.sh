#!/bin/sh

# Input variables:
#  OS_NAME
#  DOCKER_IMG_NAME
#  SETUP_COMMANDS

# Remove previous one
BUILD_DST_NAME="${OS_NAME}"
BUILD_DST_DIR="/var/www/html/BangBuilds/${OS_NAME}"
PKG_SRC_NAME="BangEditor.tar.gz"
PKG_DST_NAME="BangEditor_${OS_NAME}.tar.gz"

# Make space removing all images and containers
echo "Removing existing containers and images to make some room..."
docker rm  -f $(docker ps -a -q)
docker rmi -f $(docker images -q)

# Build commands
CMD="\
${SETUP_COMMANDS}
git clone --recurse-submodules --depth=1 https://github.com/Bang3DEngine/BangEditor
cd BangEditor/Scripts/BuildPackage
./buildPackage.sh
ls"

# Run commands in docker
docker run ${DOCKER_IMG_NAME} /bin/bash -c "$CMD"
if [ $? -ne 0 ] ; then echo "ERROR with some docker instruction." ; exit 1 ; fi

# Retrieve the build result
CONT_ID=$(docker ps -q -l)
echo "Retrieving results from $CONT_ID..."

mkdir -p ${BUILD_DST_DIR}
docker cp $CONT_ID:/BangEditor/Scripts/BuildPackage/${PKG_SRC_NAME} ${BUILD_DST_DIR}/${PKG_DST_NAME}

exit 0
