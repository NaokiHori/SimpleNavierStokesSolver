#!/bin/sh

rootdname=`pwd`
# assume file names without spaces
texfiles=`find ./ -type f -name "*.tex"`
for texfile in ${texfiles}; do
  dname=`dirname  ${texfile}`
  bname=`basename ${texfile}`
  cd ${dname}
  pdflatex ${bname}
  cd ${rootdname}
done
