#!/bin/sh

while [ /bin/true ]; do
    ssh -N -R2222:localhost:22 dylan@209.6.87.142
    sleep 10
done
