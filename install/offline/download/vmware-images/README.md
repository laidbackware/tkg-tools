# Fetch all images

## Preparation
Ensure to export all env vars.
```
export TKG_CUSTOM_IMAGE_REPOSITORY="harbor.offline.lab/tanzu"
export TKG_IMAGE_REPO="projects.registry.vmware.com/tkg"
export IMAGE_OUTPUT_DIR="/tmp/tkg-images"
```
Ensure imgpkg and yq are installed and executable. Both were downloaded in step 1.

## (optional) Collect list of releases to install and set the release
```
latest_release=$(imgpkg  tag  list -i ${TKG_IMAGE_REPO}/tkr-compatibility |sort -r |head -1);
imgpkg pull -i ${TKG_IMAGE_REPO}/tkr-compatibility:${latest_release} --output "tkr-tmp";
cat tkr-tmp/tkr-compatibility.yaml | sed 's/+_//' |sed 's/+/_/' | yq e - ;
rm -rf tkr-tmp;
# This will display the tkrs by tkg version
# Example variable defining release. Note they must be space separated.
export DEFINED_TKRS="v1.19.12_vmware.1-tkg.1 v1.20.8_vmware.1-tkg.2 v1.21.2_vmware.1-tkg.1"
export DEFINED_TKRS="v1.21.2_vmware.1-tkg.1"
```

## Run generate script
```
./gen-download-script.sh > download-images-initial.sh
# Filter out all duplicates and comments
cat download-images-initial.sh |grep -v "#" |sort -r |uniq > download-images-unique.sh

```
## Run script
If the script errors at any point, open the `download-images-unique.sh` script and comment out any completed lines. </br>
The images are collected alphabetically, followed by the bundles.
```
bash ./download-images-unique.sh
```

## Compress and validate the exported images to a single file
```
tar cvfz vmware-images.tar.gz $IMAGE_OUTPUT_DIR
```
Now generate a checksum and record the output for use on the import process.
```
md5sum vmware-images.tar.gz
# e.g output af503ac4e5453c1f841b11e278fba85f  vmware-images.tar.gz
```