#!/bin/bash

set -euo pipefail


DOWNLOAD_DIR=${DOWNLOAD_DIR:-} 
if [ -z "$DOWNLOAD_DIR" ]; then
  echo "DOWNLOAD_DIR variable is required but is not defined" >&2
  exit 1
fi
if !-f ${DOWNLOAD_DIR}/image-list; then
  echo "Image file does ${DOWNLOAD_DIR}/image-list does not exist!"
fi

commands="$(cat ${DOWNLOAD_DIR}/generated-image-list |grep imgpkg |sort |uniq)"

while IFS= read -r cmd; do
  echo -e "\nrunning $cmd\n"
  until $cmd; do
    echo -e "\nDownload failed. Retrying....\n"
    sleep 1
  done
done <<< "$commands"