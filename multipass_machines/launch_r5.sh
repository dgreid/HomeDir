#!/bin/sh

multipass launch -d 256G -m 6G -c 6 -n r5-dev --cloud-init r5-dev.yaml
