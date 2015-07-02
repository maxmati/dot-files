#!/bin/bash

#init
pushd `dirname $0` > /dev/null
SCRIPTPATH=`pwd`
popd > /dev/null
cd $SCRIPTPATH

#clean
rm -rf out/*

#create dir structure
cd out
( cd ../src ; find . -depth -type d ! -name . -print0 ) | xargs -0 mkdir -p
cd ..

#parse
for f in $(find ./src -type f ); do 
	php $f > `echo $f | sed 's:./src:./out:'`;
done


#link
prefix=`pwd`'/out/'
while read p; do
	tags=($p)
	if [ -h ${tags[1]} ] || [ ! -e ${tags[1]} ]; then
		eval out=${tags[1]}
		src=$prefix${tags[0]}
		ln -sf $src $out
	fi
done < links
