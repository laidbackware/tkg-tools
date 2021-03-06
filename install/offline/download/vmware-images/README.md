# Fetch all images

## Preparation
Login to VMware registry. VMware employees should use the NT login (not email address).
```
docker login projects.registry.vmware.com
```
Ensure to export all env vars.
```
export TKG_CUSTOM_IMAGE_REPOSITORY="harbor.offline.lab/tanzu"
export TKG_IMAGE_REPO="projects.registry.vmware.com/tkg"
export IMAGE_OUTPUT_DIR="/tmp/tkg-images"
export DOWNLOAD_DIR=$HOME/tanzu/download
```
Ensure imgpkg and yq are installed and executable. Both were downloaded in step 1.

## (optional) Collect list of releases to install and set the release
```
latest_release=$(imgpkg  tag  list -i ${TKG_IMAGE_REPO}/tkr-compatibility |sort -r |head -1);
imgpkg pull -i ${TKG_IMAGE_REPO}/tkr-compatibility:${latest_release} --output "tkr-tmp";
cat tkr-tmp/tkr-compatibility.yaml | sed 's/+_//' |sed 's/+/_/' | yq e - ;
rm -rf tkr-tmp;

imgpkg pull -i ${TKG_IMAGE_REPO}/tkr-compatibility:v$(imgpkg  tag  list -i ${TKG_IMAGE_REPO}/tkr-compatibility |sed 's/v//' |sort -rn |head -1) --output "tkr-tmp"; cat tkr-tmp/tkr-compatibility.yaml | sed 's/+_//' |sed 's/+/_/' | yq e - ; rm -rf tkr-tmp;

# This will display the tkrs by tkg version
# Example variable defining release. Note they must be space separated.
export DEFINED_TKRS="v1.19.12_vmware.1-tkg.1 v1.20.8_vmware.1-tkg.2 v1.21.2_vmware.1-tkg.1"
export DEFINED_TKRS="v1.21.2_vmware.1-tkg.1"
```

## Run generate script
```
./gen-download-script.sh > ${DOWNLOAD_DIR:?}/image-list
# Filter out all duplicates and comments
```
## Run script
If the script errors at any point, open the `download-images-unique.sh` script and comment out any completed lines. </br>
The images are collected alphabetically, followed by the bundles.
```
./download-images.sh
```

## Compress and validate the exported images to a single file
```
tar -C $IMAGE_OUTPUT_DIR -cf ${DOWNLOAD_DIR:?}/vmware-images.tar .
```
Now generate a checksum and record the output for use on the import process.
```
md5sum ${DOWNLOAD_DIR:?}/vmware-images.tar.gz
# e.g output af503ac4e5453c1f841b11e278fba85f  ${DOWNLOAD_DIR:?}/vmware-images.tar.gz
```
Tidy up `rm ${DOWNLOAD_DIR:?}/image-list`