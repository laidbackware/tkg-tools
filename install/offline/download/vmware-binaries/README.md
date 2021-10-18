# Download VMware binaries
Browse to (https://customerconnect.vmware.com/downloads/details?downloadGroup=TKG-140&productId=988&rPId=53095)[https://customerconnect.vmware.com/downloads/details?downloadGroup=TKG-140&productId=988&rPId=53095] </br>

Download:
- tanzu-cli-bundle-linux-amd64.tar
- ubuntu-2004-kube-v1.21.2+vmware.1-tkg.1-7832907791984498322
- kubectl-linux-v1.21.2+vmware.1.gz
- velero-linux-v1.6.2_vmware.1.gz

## Install the Tanzu CLI.
Install the Tanzu CLI locally.
```
sudo mkdir -p /tanzu
sudo chown -R $USER:$USER /tanzu
tar xvf tanzu-cli-bundle-linux-amd64.tar -C /tanzu

sudo install /tanzu/cli/core/v1.4.0/tanzu-core-linux_amd64 /usr/local/bin/tanzu
tanzu version
```