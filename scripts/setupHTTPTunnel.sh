#!/bin/bash
while [ /bin/true ]; do
    ssh -N -D 8080 dylan@209.6.87.142
    sleep 10
done

