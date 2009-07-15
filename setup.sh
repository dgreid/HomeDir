#!/bin/bash
PWD=`pwd`
for i in `find . -maxdepth 1 -name '*[a-zA-Z]*' | grep -v setup.sh`
do
	ln -s $PWD/$i ~/$i
done
