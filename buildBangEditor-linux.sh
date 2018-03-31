#!/bin/sh

OS_NAME="Linux"
VERSION="0.0"
DOCKER_IMG_NAME="debian:jessie"
SETUP_COMMANDS="
apt-get update
apt-get -y install git cmake make gcc g++ autogen libtool automake autoconf libglu1-mesa-dev libopenal-dev libsndfile-dev zlib1g-dev 
export PATH=$PATH:/usr/lib/x86_64-linux-gnu
"

. "./buildBangEditor.sh"
