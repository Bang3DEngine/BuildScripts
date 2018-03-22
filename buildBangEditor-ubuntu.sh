#!/bin/sh

# Remove previous one
BUILD_DST_NAME="BangEditor-0.0_Ubuntu_64"
BUILD_DST_DIR="/var/www/html/BangBuilds/${BUILD_DST_NAME}"

# Build commands
CMD="\
apt-get update
apt-get install -y git build-essential cmake make libglew-dev libpng-dev libjpeg-dev libsdl2-dev libsdl2-ttf-dev libfreetype6-dev libopenal-dev libassimp-dev libsndfile-dev
git clone https://github.com/Bang3DEngine/Bang
git clone https://github.com/Bang3DEngine/BangEditor
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
docker run ubuntu /bin/bash -c "$CMD"

# Retrieve the build result
CONT_ID=$(docker ps -q -l)
echo "Retrieving results from $CONT_ID..."
docker cp $CONT_ID:/BangEditor/Scripts/BuildPackage/BangEditorPackage ${BUILD_DST_DIR}

exit
