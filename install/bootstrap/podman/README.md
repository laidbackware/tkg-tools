# How to use rootless Podman to bootstrap TKG
This procedure was tested on Ubuntu 21.10 which uses cgroups v2 be default.</br>
If podman is not already installed.
```
sudo apt-get -y update
sudo apt-get -y install podman
```

## Pre-reqs
The OS must be running with cgroups v2, which is enabled on 21.10 and 22.04.</br>
Check [https://kind.sigs.k8s.io/docs/user/rootless/](https://kind.sigs.k8s.io/docs/user/rootless/) for updates
### Delegation Mode
Ubuntu requires [Delegation](https://www.freedesktop.org/wiki/Software/systemd/ControlGroupInterface/) mode to be enabled to allow a service to manage its subtree.
```
# Ensure directory exists
sudo mkdir -p /etc/systemd/system/user@.service.d/

# Create file
sudo tee /etc/systemd/system/user@.service.d/delegate.conf > /dev/null <<EOT
[Service]
Delegate=yes
EOT
```

### Install Kind
[Install docs](https://kind.sigs.k8s.io/docs/user/quick-start/#installation).

## Prepare Kind Cluster
To set Podman as the provider run:
```
export KIND_EXPERIMENTAL_PROVIDER=podman
```
Now Kind commands will work as expected via Podman
```
kind create cluster
```
### Validate the cluster
Assuming the default cluster name, set the context.
```
kubectl config use-context kind-kind
```
Ensure that the base Kind pods are running at expected.
```
kubectl get pods -A
```

## Bootstrapping TKG
For the boot strapping to work with a private registry either the CA cert needs to be passed in, or Kind should be set to skip TLS verification. After the cluster is running, you must copy in your cert, update the ca store and restart containerd.
```
podman cp /home/matt/.local/share/mkcert/rootCA.pem "kind-control-plane:/usr/local/share/ca-certificates/ca.crt"podman exec kind-control-plane update-ca-certificates
podman exec kind-control-plane systemctl restart containerd
```
Now when running the bootstrap commands they can be appended with `--use-existing-bootstrap-cluster` to use the kind cluster which is the current context. </br>
Official docs [here](https://docs.vmware.com/en/VMware-Tanzu-Kubernetes-Grid/1.4/vmware-tanzu-kubernetes-grid-14/GUID-troubleshooting-tkg-use-existing.html).
Note that the kubectl context must be the kind cluster.
```
tanzu management-cluster create --file mgmt_cluster.yml --use-existing-bootstrap-cluster
```

