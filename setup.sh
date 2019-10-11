#!/bin/bash
PWD=`pwd`
for i in `find . -maxdepth 1 -name '*[a-zA-Z]*' | grep -v setup.sh | grep -v '.git' | grep -v '.ssh'`
do
	rm -f ~/$i
	ln -s $PWD/$i ~/$i
done
ln -s $PWD/.git-completion.bash ~
ln -s $PWD/.gitconfig ~
mkdir -p ~/.ssh
ln -s $PWD/.ssh/config ~/.ssh/config
