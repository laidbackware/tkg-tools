#!/bin/bash
# Copyright 2021 VMware, Inc. All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0
# Original script from https://docs.vmware.com/en/VMware-Tanzu-Kubernetes-Grid/1.4/vmware-tanzu-kubernetes-grid-14/GUID-mgmt-clusters-airgapped-environments.html

set -euo pipefail

TANZU_BOM_DIR=${HOME}/.config/tanzu/tkg/bom
INSTALL_INSTRUCTIONS='See https://github.com/mikefarah/yq#install for installation instructions'
TKG_CUSTOM_IMAGE_REPOSITORY=${TKG_CUSTOM_IMAGE_REPOSITORY:-''}
TKG_IMAGE_REPO=${TKG_IMAGE_REPO:-''}

#CHANGES!! add passing in of dir to host images
IMAGE_OUTPUT_DIR=${IMAGE_OUTPUT_DIR:-} 
if [ -z "$IMAGE_OUTPUT_DIR" ]; then
  echo "IMAGE_OUTPUT_DIR variable is required but is not defined" >&2
  exit 1
fi
# Add subdirectories
mkdir -p ${IMAGE_OUTPUT_DIR}/vmware-images/images ${IMAGE_OUTPUT_DIR}/vmware-images/bundles
#\CHANGES

echodual() {
  echo "$@" 1>&2
  echo "#" "$@"
}

if [ -z "$TKG_CUSTOM_IMAGE_REPOSITORY" ]; then
  echo "TKG_CUSTOM_IMAGE_REPOSITORY variable is required but is not defined" >&2
  exit 1
fi

if [ -z "$TKG_IMAGE_REPO" ]; then
  echo "TKG_IMAGE_REPO variable is required but is not defined" >&2
  exit 2
fi

if ! [ -x "$(command -v imgpkg)" ]; then
  echo 'Error: imgpkg is not installed.' >&2
  exit 3
fi

if ! [ -x "$(command -v yq)" ]; then
  echo 'Error: yq is not installed.' >&2
  echo "${INSTALL_INSTRUCTIONS}" >&2
  exit 3
fi

function imgpkg_copy() {
    flags=$1
    src=$2
    #CHANGES
    case $flags in # Set separate output directories for download type
      -i)
        output_dir=$IMAGE_OUTPUT_DIR/vmware-images/images
        ;;
      -b)
        output_dir=$IMAGE_OUTPUT_DIR/vmware-images/bundles
        ;;
    esac
    # Replace all slashes in images names to underscores
    dst=${3//\//_} 
    # tar images instead of copying to registry
    echo -e "\nimgpkg copy $flags $src --to-tar $output_dir/$dst.tar" 
    #|CHANGES
}

echo "set -euo pipefail"
echodual "Note that yq must be version above or equal to version 4.9.2 and below version 5."

actualImageRepository="$TKG_IMAGE_REPO"

# Iterate through TKG BoM file to create the complete Image name
# and then pull, retag and push image to custom registry.
list=$(imgpkg  tag  list -i "${actualImageRepository}"/tkg-bom)
for imageTag in ${list}; do
  tanzucliversion=$(tanzu version | head -n 1 | cut -c10-15)
  if [[ ${imageTag} == ${tanzucliversion}* ]]; then
    TKG_BOM_FILE="tkg-bom-${imageTag//_/+}.yaml"
    imgpkg pull --image "${actualImageRepository}/tkg-bom:${imageTag}" --output "tmp" > /dev/null 2>&1
    echodual "Processing TKG BOM file ${TKG_BOM_FILE}"

    actualTKGImage=${actualImageRepository}/tkg-bom:${imageTag}
    customTKGImage=${TKG_CUSTOM_IMAGE_REPOSITORY}/tkg-bom
    imgpkg_copy "-i" $actualTKGImage $customTKGImage

    # Get components in the tkg-bom.
    # Remove the leading '[' and trailing ']' in the output of yq.
    components=(`yq e '.components | keys | .. style="flow"' "tmp/$TKG_BOM_FILE" | sed 's/^.//;s/.$//'`)
    for comp in "${components[@]}"
    do
      # remove: leading and trailing whitespace, and trailing comma
      comp=`echo $comp | sed -e 's/^[[:space:]]*//' | sed 's/,*$//g'`
      get_comp_images="yq e '.components[\"${comp}\"][]  | select(has(\"images\"))|.images[] | .imagePath + \":\" + .tag' "\"tmp/\"$TKG_BOM_FILE""

      flags="-i"
      if [ $comp = "tkg-standard-packages" ]; then
        flags="-b"
      fi
      eval $get_comp_images | while read -r image; do
          actualImage=${actualImageRepository}/${image}
          image2=$(echo "$image" | cut -f1 -d":")
          customImage=$TKG_CUSTOM_IMAGE_REPOSITORY/${image2}
          imgpkg_copy $flags $actualImage $customImage
        done
    done

    rm -rf tmp
    echodual "Finished processing TKG BOM file ${TKG_BOM_FILE}"
    echo ""
  fi
done

# Iterate through TKR BoM file to create the complete Image name
# and then pull, retag and push image to custom registry.
list=${DEFINED_TKRS:-$(imgpkg  tag  list -i ${actualImageRepository}/tkr-bom)} #CHANGED!! add default value to allow TKRs to be defined
for imageTag in ${list}; do
  if [[ ${imageTag} == v* ]]; then
    TKR_BOM_FILE="tkr-bom-${imageTag//_/+}.yaml"
    echodual "Processing TKR BOM file ${TKR_BOM_FILE}"

    actualTKRImage=${actualImageRepository}/tkr-bom:${imageTag}
    customTKRImage=${TKG_CUSTOM_IMAGE_REPOSITORY}/tkr-bom
    imgpkg_copy "-i" $actualTKRImage $customTKRImage
    imgpkg pull --image ${actualImageRepository}/tkr-bom:${imageTag} --output "tmp" > /dev/null 2>&1

    # Get components in the tkr-bom.
    # Remove the leading '[' and trailing ']' in the output of yq.
    components=(`yq e '.components | keys | .. style="flow"' "tmp/$TKR_BOM_FILE" | sed 's/^.//;s/.$//'`)
    for comp in "${components[@]}"
    do
    # remove: leading and trailing whitespace, and trailing comma
    comp=`echo $comp | sed -e 's/^[[:space:]]*//' | sed 's/,*$//g'`
    get_comp_images="yq e '.components[\"${comp}\"][]  | select(has(\"images\"))|.images[] | .imagePath + \":\" + .tag' "\"tmp/\"$TKR_BOM_FILE""

    flags="-i"
    if [ $comp = "tkg-core-packages" ]; then
      flags="-b"
    fi
    eval $get_comp_images | while read -r image; do
        actualImage=${actualImageRepository}/${image}
        image2=$(echo "$image" | cut -f1 -d":")
        customImage=$TKG_CUSTOM_IMAGE_REPOSITORY/${image2}
        imgpkg_copy $flags $actualImage $customImage
      done
    done

    rm -rf tmp
    echodual "Finished processing TKR BOM file ${TKR_BOM_FILE}"
    echo ""
  fi
done

list=$(imgpkg  tag  list -i ${actualImageRepository}/tkr-compatibility)
for imageTag in ${list}; do
  if [[ ${imageTag} == v* ]]; then
    echodual "Processing TKR compatibility image"
    actualImage=${actualImageRepository}/tkr-compatibility:${imageTag}
    customImage=$TKG_CUSTOM_IMAGE_REPOSITORY/tkr-compatibility
    imgpkg_copy "-i" $actualImage $customImage
    echo ""
    echodual "Finished processing TKR compatibility image"
  fi
done

list=$(imgpkg  tag  list -i ${actualImageRepository}/tkg-compatibility)
for imageTag in ${list}; do
  if [[ ${imageTag} == v* ]]; then
    echodual "Processing TKG compatibility image"
    actualImage=${actualImageRepository}/tkg-compatibility:${imageTag}
    customImage=$TKG_CUSTOM_IMAGE_REPOSITORY/tkg-compatibility
    imgpkg_copy "-i" $actualImage $customImage
    echo ""
    echodual "Finished processing TKG compatibility image"
  fi
done