#!/bin/bash

VERSION=2.7.10
PYTHONHOME=~/python2.7

mkdir -p ~/src
if [ ! -f ~/src/Python-$VERSION.tgz ]; then
    cd ~/src
    wget https://www.python.org/ftp/python/$VERSION/Python-$VERSION.tgz
    tar -xzf Python-$VERSION.tgz
fi
cd ~/src/Python-$VERSION
./configure --prefix=$PYTHONHOME
PREFIX=$PYTHONHOME make
PREFIX=$PYTHONHOME make install
