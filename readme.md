# Immediately blame the network on your clusters

## About provided soltion
Solution based on chaos mesh and provide a chaos testing interface on two clusters. It can easily scale out, if you will repeat steps written below.

# Common definitions:
1. Base cluster - a cluster, which will be used as main(master) cluster.
2. External cluster - a cluster, which will be used as replica cluster.

# Deps
This solution use minikube, kubectl and helm as core instruments, so to use written solution make sure that you have already installed minikube, kubectl and helm or you can try to `basic-setup/basic-deps-install.sh` script to install all deps(works only for linux systems).

# Testing all installed stuff on 
1. Add `grafana.local`, `chaos-mesh-1.local` and `prometheus.local` to localhost `/etc/hosts` like we did it before. For intance if `prometheus.local` was instlled on base cluster, so new row will be:
    - `ip prometheus.local`, where ip is ip of base cluster

# Install stesps
All steps to install soltion writeen in this [instruction](setup/readme.md).

# What if i have / want to have more than two clusters in my application?
You should use one of two main ways to install provided soltuion two base and external cluster. Then you should run this [instruction](setup/scaling/readme.md).
