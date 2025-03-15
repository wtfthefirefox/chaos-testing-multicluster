# Run chaos on local machine

# Steps to run:
1. Ensure that steps described in Deps header acquired.
2. Run `setup/exist/local/setup-clusters.sh` script.
3. Add records to `/etc/hosts` with an ip from `minikube ip -p base` and it would be like `192.168.*.*`:
    ```
    192.168.*.* grafana.local
    192.168.*.* chaos-mesh-1.local
    192.168.*.* chaos-mesh-daemon-metrics-1.local
    192.168.*.* prometheus.local
    ```

# How to check if it works?
1. Grafana will be available at grafana.local.
2. Chaos mesh will be available at chaos-mesh-1.local.
3. Prometheus will be available at prometheus.local.

# Steps to clear everything after your exps
1. Run `teardown-kind.sh` script.

# Common errors
1. If you have a errors like 'too many open files' in failing chaos-controller, try to run `sudo sysctl fs.inotify.max_user_watches=655360` and `sudo sysctl fs.inotify.max_user_instances=1280`.
2. External chaos cluster somehow can disconnect and to solve it you need to register remote cluster like we did at install steps. It has more stability, when we install on two separate hosts.
3. Metrics from external cluster will be not available.
