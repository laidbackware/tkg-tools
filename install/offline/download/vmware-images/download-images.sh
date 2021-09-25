#!/bin/bash

set -euo pipefail


commands="$(cat image-list |grep imgpkg |sort |uniq)"

# echo "Starting download of $(echo \"$commands\" |wc -l) images/bundles"

while IFS= read -r cmd; do
  echo "running $cmd"
  until $cmd; do
    echo "Download failed. Retrying...."
    sleep 1
  done
done <<< "$commands"