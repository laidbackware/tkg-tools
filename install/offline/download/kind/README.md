## Download kind image
Docker-ce must be installed
```
# remove all stale images from the registry
docker system prune
# 
docker pull kindest/node:v1.21.1@sha256:69860bda5563ac81e3c0057d654b5253219618a22ec3a346306239bba8cfa1a6
docker save kindest/node -o kind.image
```