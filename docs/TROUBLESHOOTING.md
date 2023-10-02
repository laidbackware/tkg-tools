# Node SSH Access
username is capv for vsphere
Run `export KUBECONFIG=/etc/kubernetes/admin.conf` on control-plane to connect to the api.

# Bootstrap troubleshooting
## Pre management move
...
## Post management move
SSH onto the CP node and `sudo -i`. </br>
Check containers with:
```
crictl ps
```
Check if the api server is available.
```
kubectl get pod -A
```

Check logs on all the nodes with:
```
grep -R -i stderr /var/log/pods/*
grep -R -i error /var/log/pods/*
grep -R -i fail /var/log/pods/*
```

Check the state of services
```
systemctl --type service
```

Check Kubelet
```
less /var/log/cloud-init-output.log
journalctl -xeu  cloud-final

systemctl status kubelet  --no-pager --full
journalctl -xeu kubelet
crictl images ls
```

Check API service
```
export KUBECONFIG=/etc/kubernetes/admin.conf
kubectl get po -A
```

# Kapp
Pause a package from being remediated with `kubectl patch packageinstall/antrea -n tkg-system -p '{"spec":{"paused":true}}' --type=merge`