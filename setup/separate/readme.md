# Install on two separated hosts

# Steps to install:
1. On external cluster:
    1. Run `setup/common/setup_external_cluster.sh` script.
    2. Copy value of `K8s-yaml-files/secret-kubeconfig.yaml` file to base cluster folder.
    3. Add new rows to `/etc/hosts` file with ip from `minikube ip -p external`:
        - `192.168.*.* chaos-mesh-dashboards-metrics-2.local`
        - `192.168.*.* chaos-mesh-controller-metrics-2.local`
        - `192.168.*.* chaos-mesh-2.local`
2. On base cluster:
    1. Make sure that you have a copy of `K8s-yaml-files/secret-kubeconfig.yaml` from external cluster.
    2. Add to some rows to `/etc/hosts` file with ip from seconds cluster ip:
        - `*.*.*.* chaos-mesh-dashboards-metrics-2.local`
        - `*.*.*.* chaos-mesh-controller-metrics-2.local`
        - `*.*.*.* chaos-mesh-2.local`
    3. Run `setup/common/setup_base_cluster.sh`
    4. Add values from current cluster to `/etc/hosts` with ip of current cluster(`minikube ip`):
        - `192.168.*.* chaos-mesh-dashboards-metrics-1.local`
        - `192.168.*.* chaos-mesh-controller-metrics-1.local`
        - `192.168.*.* chaos-mesh-1.local`
        - `192.168.*.* grafana.local`
        - `192.168.*.* prometheus.local`
