# Install OVA Images

## Prerequisites
Govc must be installed </br>
The vCenter connetion details must be exported.</br>
Add space at begenning of every line containing a secret to prevent it being in the bash history.
```
export GOVC_URL=https://192.168.1.50
export GOVC_USERNAME=administrator@vsphere.local
 export GOVC_PASSWORD=VMware1!
# If no using a CA signed cert for the vCenter
export GOVC_INSECURE=true
or
export GOVC_TLS_CA_CERTS=<path to public key>
```
Verify connection with `govc ls`

## Upload the Template
Collect cluster path
```
govc ls
# Then again with datacenter
govc ls /<datacenter>/host
e.g
govc ls /Lab/host
```

Import the ova with a generic spec
```
govc import.ova -name=<VM name> -ds=<datastore name> -host=<cluster path> -dc=<datacenter name> <FILENAME>
#e.g
govc import.ova -name=ubuntu-2004-kube-v1.21.2+vmware.1-tkg.1 -ds=datastore-esx1 -host=/Lab/host/compute -dc=Lab ubuntu-2004-kube-v1.21.2+vmware.1-tkg.1-7832907791984498322.ova
```

Convert the VM to a template
```
govc vm.markastemplate -dc=<datacenter name> <vm name>
govc vm.markastemplate -dc=Lab ubuntu-2004-kube-v1.21.2+vmware.1-tkg.1
```