#!/bin/sh

multipass launch jammy --name r5-dev --cloud-init ./r5-dev.yaml --mem 16G --cpus 8 --disk 256G
