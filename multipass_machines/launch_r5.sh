#!/bin/sh

multipass launch -d 256G -m 6G -c 6 -n r5_dev --cloud-init r5_dev.yaml
