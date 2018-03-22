#!/bin/sh

OS_NAME="Ubuntu-Xenial-64"
VERSION="0.0"
DOCKER_IMG_NAME="ubuntu:xenial"
SETUP_COMMANDS="
apt-get update
apt-get install -y git build-essential cmake make libglew-dev libassimp-dev libsndfile-dev libopenal-dev libpng-dev libjpeg-dev libsdl2-dev libsdl2-ttf-dev libfreetype6-dev
"

. "./buildBangEditor.sh"
