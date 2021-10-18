#!/bin/bash
# Copyright 2021 VMware, Inc. All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0
# Original script from https://docs.vmware.com/en/VMware-Tanzu-Kubernetes-Grid/1.4/vmware-tanzu-kubernetes-grid-14/GUID-mgmt-clusters-airgapped-environments.html

set -euo pipefail

INSTALL_INSTRUCTIONS='See https://github.com/mikefarah/yq#install for installation instructions'
TKG_CUSTOM_IMAGE_REPOSITORY=${TKG_CUSTOM_IMAGE_REPOSITORY:-''}
IMAGE_LOCATION=${IMAGE_LOCATION:-''}

echodual() {
  echo "$@" 1>&2
  echo "#" "$@"
}

if [ -z "$TKG_CUSTOM_IMAGE_REPOSITORY" ]; then
  echo "TKG_CUSTOM_IMAGE_REPOSITORY variable is required but is not defined" >&2
  exit 1
fi

if [ -z "$IMAGE_LOCATION" ]; then
  echo "IMAGE_LOCATION variable is required but is not defined" >&2
  exit 2
fi

if ! [ -x "$(command -v imgpkg)" ]; then
  echo 'Error: imgpkg is not installed.' >&2
  exit 3
fi

file_types="images bundles"
for file_type in $file_types; do
  for file_path in $IMAGE_LOCATION/$file_type/*; do
    filename=$(basename -- "$file_path")
    echo -e "$filename\n"
    image_name=$(basename -- "$file_path" | sed 's/~.*//')
    image_name=${image_name/"harbor.fqdn]harbor-project]"/"$TKG_CUSTOM_IMAGE_REPOSITORY/"}
    image_name=${image_name/"~"/":"}
    image_name=${image_name//"]"/"/"}
    image_name=${image_name/".tar"/""}
    push_flag="-i"
    if [ $file_type == "bundles" ]; then
      push_flag="-b"
    fi
    echo -e "$image_name \n"
    # echo "imgpkg copy $push_flag $image_name --tar $file_path"
    # imgpkg copy $push_flag $image_name --tar $file_path
    imgpkg copy --tar $file_path --to-repo $image_name 
  done
done
