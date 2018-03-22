#!/bin/sh

# Input variables:
#  OS_NAME
#  DOCKER_IMG_NAME
#  VERSION
#  SETUP_COMMANDS

# Remove previous one
BUILD_DST_NAME=${OS_NAME}
BUILD_DST_DIR="/var/www/html/BangBuilds/${OS_NAME}/${VERSION}"
PKG_SRC_NAME="BangEditorPackage"
PKG_DST_NAME="BangEditor_${OS_NAME}_${VERSION}"

# Make space removing all images and containers
echo "Removing existing containers and images to make some room..."
docker rm  -f $(docker ps -a -q)
docker rmi -f $(docker images -q)

# Build commands
CMD="\
${SETUP_COMMANDS}
git clone --depth 1 https://github.com/Bang3DEngine/Bang
git clone --depth 1 https://github.com/Bang3DEngine/BangEditor
cd BangEditor
cd Scripts
./setBangPath.sh /Bang
cd BuildPackage
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release ..
make -j6
ls"

# Run commands in docker
docker run ${DOCKER_IMG_NAME} /bin/bash -c "$CMD"
if [ $? -ne 0 ] ; then echo "ERROR with some docker instruction." ; exit 1 ; fi

# Retrieve the build result
CONT_ID=$(docker ps -q -l)
echo "Retrieving results from $CONT_ID..."

mkdir -p ${BUILD_DST_DIR}
docker cp $CONT_ID:/BangEditor/Scripts/BuildPackage/BangEditorPackage ${BUILD_DST_DIR}/${PKG_SRC_NAME}

# Make tar and remove dir
cd "${BUILD_DST_DIR}"
rm -rf "${PKG_DST_NAME}"
tar -czvf "${PKG_DST_NAME}.tar.gz" "${PKG_SRC_NAME}"
rm -rf "${PKG_SRC_NAME}"

exit 0
