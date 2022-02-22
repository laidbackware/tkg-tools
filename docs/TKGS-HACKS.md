## Re-pave a cluster
```
kubectl patch machinedeployments.cluster.x-k8s.io <TEMPLATE_NAME> --type merge -p "{\"spec\":{\"template\":{\"metadata\":{\"annotations\":{\"date\":\"`date +'%s'`\"}}}}}"
```