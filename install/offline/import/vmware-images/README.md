# Fetch all images

## Preparation
Ensure to export all env vars and create directories.
```
sudo mkdir -p /tanzu/vmware-images
sudo chown $USER:$USER /tanzu/vmware-images
export TKG_CUSTOM_IMAGE_REPOSITORY="harbor.offline.lab/tanzu"
export IMAGE_LOCATION="/tanzu/vmware-images"
```
Ensure imgpkg is installed and executable.

## Transfer images, validate and decompress
Validate checksum matches the source file which was recorded at download
```
md5sum vmware-images.tar.gz
```
Extract the images.
```
export IMAGE_LOCATION=/tanzu/vmware-images
tar xvf vmware-images.tar.gz -C $IMAGE_LOCATION
```

## Run the import script to import all images and bundles
Ensure IMAGE_LOCATION and TKG_CUSTOM_IMAGE_REPOSITORY is exported.</br>
```
./import-script.sh
```