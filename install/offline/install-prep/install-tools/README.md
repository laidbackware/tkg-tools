# Install all tools
Run `sudo ls` to cache the sudo login temporarily.</br>

```
mkdir /tmp/tanzu-tools
# GOVC
tar xvfz govc_Linux_x86_64.tar.gz -C /tmp/tanzu-tools
chmod +x /tmp/tanzu-tools/govc
sudo mv /tmp/tanzu-tools/govc /usr/local/bin/govc
rm /tmp/tanzu-tools/*

# Tanzu CLI
sudo mkdir -p /tanzu
sudo chown -R $USER:$USER /tanzu
tar xvf tanzu-cli-bundle-linux-amd64.tar -C /tanzu

sudo install /tanzu/cli/core/v1.4.0/tanzu-core-linux_amd64 /usr/local/bin/tanzu
tanzu version
```


