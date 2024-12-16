# Install on two separated hosts

# Steps to install:
1. On external cluster:
    1. Run `setup/common/setup_external_cluster.sh` script.
    2. Copy value of `K8s-yaml-files/secret-kubeconfig.yaml` to base cluster folder.
    3. Add to `chaos-mesh-dashboards-metrics-2.local`, `chaos-mesh-controller-metrics-2.local` and `chaos-mesh-2.local` to `/etc/hosts` with ip from `minikube ip`:
        - `192.168.*.* chaos-mesh-dashboards-metrics-2.local`
2. On base cluster:
    1. Make sure that you have a copy of `K8s-yaml-files/secret-kubeconfig.yaml` from external cluster.
    2. Run `setup/common/setup_base_cluster.sh`
    3. Add values from external cluster such as `chaos-mesh-dashboards-metrics-2.local`, `chaos-mesh-controller-metrics-2.local` and `chaos-mesh-2.local` to to `/etc/hosts` with ip of external cluster:
        - `*.*.*.* chaos-mesh-dashboards-metrics-2.local`
    4. The same thing we do for our base cluster and `grafana.local` and `prometheus.local`, but ip will be `minikube ip`.
