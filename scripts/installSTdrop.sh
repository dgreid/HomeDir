#!/bin/sh
sudo rm -rf STLinux-2.3/
sudo tar xzf /tools/hepdsw/STM/STLinux-2.3-$1.tgz
cd STLinux-2.3
sudo /scratch/Defender/Balboa/7200/STLinuxKernelPatches/$1/apply_patches.sh
cd ..
# do some chown/chmod work so I don't have to 'sudo' my builds
sudo chmod -R a+rw STLinux-2.3/devkit/sh4/target/lib/
sudo chmod -R a+rw STLinux-2.3/devkit/sh4/target/boot/
sudo chmod -R a+rwx STLinux-2.3/devkit/sh4/target/root/
sudo chmod -R a+rw STLinux-2.3/devkit/sh4/target/etc
sudo chown -R `whoami` STLinux-2.3/devkit/sources
sudo chown -R `whoami` STLinux-2.3/devkit/build
# cd to the build directory and kick off the build
cd /opt/STM/STLinux-2.3/devkit/build/havana-build.cb104
make all
