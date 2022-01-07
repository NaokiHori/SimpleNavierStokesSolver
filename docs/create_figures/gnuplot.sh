#!/bin/sh

rootdname=`pwd`
# assume file names without spaces
gpfiles=`find ./ -type f -name "*.gp"`
# for each gnuplot script *.gp
for gpfile in ${gpfiles}; do
  dname=`dirname  ${gpfile}`
  bname=`basename ${gpfile}`
  cd ${dname}
  # create temporary files (*.eps, *.tex)
  gnuplot ${bname}
  # go back to root directory
  cd ${rootdname}
done
