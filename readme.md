# Immediately blame the network

# Deps
Before run code check that you have already installed minikube, kubectl and helm or you can try to `/basic-deps-install.sh` script to install all deps(works only for linux systems).

# Steps to run:
1. Ensure that steps described in Deps header acquired
2. Run setup-clusters.sh
3. Add grafana.local, chaos-mesh-1.local, chaos-mesh-daemon-metrics.local and prometheus.local to `/etc/hosts`

# Steps to clear everything after your exps
1. Run `teardown-kind.sh` script
