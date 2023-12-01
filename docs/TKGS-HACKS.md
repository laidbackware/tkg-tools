# How to access the Tanzu with vSphere Products

## SSH to the Supervisor Cluster nodes
On the vCenter run to get supervisor creds `/usr/lib/vmware-wcp/decryptK8Pwd.py`

SSH to supervisor VM as root.

## SSH to the Guest Cluster nodes
Commands should be run on the supervisor cluster.
### Using private keys
```
kubectl get secret -n <namespace> <cluster name>-ssh -o jsonpath={.data."ssh-privatekey"}  | base64 -d | tee -a privatekey.key
chmod 600 privatekey.key
ssh -i privatekey.key vmware-system-user@<guest_IP>
```
### Using the password
```
kubectl get secret -n <namespace> <cluster name>-ssh-password -o jsonpath={.data."ssh-passwordkey"} | base64 -d
ssh vmware-system-user@<guest_IP>
```

### Running commands without kubectl, for debugging
crictl mirrors kubectl
```
sudo crtictl exec pod
sudo crictl ps
sudo crictl logs <container ID>
# System containers do not have a shell!
sudo crictl exec <container ID> /bin/sh

```

### Getting kubectl inside a workload cluster
```
sudo -i
export KUBECONFIG=/etc/kubernetes/admin.conf
```

## Harbor Admin UI Access
kubectl commands must be run from inside a supervisor cluster VM.
```
HARBOR_NAMESPACE=$(kubectl get ns | grep registry- | awk '{print $1}')
HARBOR_POD_ID=$(echo $HARBOR_NAMESPACE | sed 's/.*-//')
kubectl get secret -n $HARBOR_NAMESPACE harbor-$HARBOR_POD_ID-controller-registry -o=jsonpath='{.data.harborAdminUsername}' |base64 -d |base64 -d
kubectl get secret -n $HARBOR_NAMESPACE harbor-$HARBOR_POD_ID-controller-registry -o=jsonpath='{.data.harborAdminPassword}' |base64 -d |base64 -d
```

# Re-pave a cluster
```
kubectl patch machinedeployments.cluster.x-k8s.io <TEMPLATE_NAME> --type merge -p "{\"spec\":{\"template\":{\"metadata\":{\"annotations\":{\"date\":\"`date +'%s'`\"}}}}}"
```
