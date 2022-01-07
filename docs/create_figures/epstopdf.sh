#!/bin/sh

rootdname=`pwd`
# assume file names without spaces
epsfiles=`find ./ -type f -name "*.eps"`
for epsfile in ${epsfiles}; do
  dname=`dirname  ${epsfile}`
  bname=`basename ${epsfile}`
  cd ${dname}
  epstopdf ${bname}
  cd ${rootdname}
done
