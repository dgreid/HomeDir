#!/bin/sh
qemu-system-aarch64 -nographic -kernel ~/Downloads/vm_kernel -hda ~/aarch64.debian.ext4 -append "root=/dev/vda rw" -M virt,highmem=off -accel hvf -cpu cortex-a72 -smp 8 -m 6144 -nic user,model=virtio,hostfwd=tcp:127.0.0.1:9922-0.0.0.0:22
