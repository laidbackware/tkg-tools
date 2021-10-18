# Initialize Tanzu CLI

## Pre-requisites
Ensure that the CA cert is setup</br>
Ensure that the images are pushed into the registry</br>
Ensure that the env vars are exported.</br>
```
export TKG_CUSTOM_IMAGE_REPOSITORY=harbor.offline.lab/tanzu
export TKG_CUSTOM_IMAGE_REPOSITORY_SKIP_TLS_VERIFY=false
```

## Setup Tanzu CLI Plugins
Initialize the CLI
```
tanzu config init
```
Initialize the plugins
```
cd /tanzu
tanzu plugin install --local cli all
```