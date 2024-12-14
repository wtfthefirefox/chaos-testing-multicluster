# Immediately blame the network

# Deps
Before run code check that you have already installed minikube, kubectl and helm or you can try to `basic-setup/basic-deps-install.sh` script to install all deps(works only for linux systems).

# Steps to run:
1. Ensure that steps described in Deps header acquired
2. Run setup-clusters.sh
3. Add grafana.local, chaos-mesh-1.local, chaos-mesh-daemon-metrics.local and prometheus.local to `/etc/hosts` wtih ip from `minikube ip -p base`:
- `192.168.*.* grafana.local`

# How to check if it works?
1. Grafana will be available at grafana.local.
2. Chaos mesh will be available at chaos-mesh-1.local.
3. Prometheus will be available at prometheus.local

# Steps to clear everything after your exps
1. Run `teardown-kind.sh` script

# Common errors
1. If you have a errors like 'too many open files' in failing chaos-controller, try to run `sudo sysctl fs.inotify.max_user_watches=655360`.
