#!/bin/bash

for f in ./build*-*.sh
do
  ./$f
  if [ $? -ne 0 ] ; then echo "Error building $f..." ; fi
done
