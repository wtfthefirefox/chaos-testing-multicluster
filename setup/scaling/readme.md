# Scaling up our chaos
This instruction will describe a way to scaling up your chaos on two or more clusters

# Steps to install:
1. On new external cluster `I`:
    1. Run `setup/common/setup_external_cluster.sh` script.
    2. Copy value of `K8s-yaml-files/secret-kubeconfig.yaml` to base cluster folder.
    3. Add to `chaos-mesh-dashboards-metrics-I.local`, `chaos-mesh-controller-metrics-I.local` and `chaos-mesh-I.local` to `/etc/hosts` with ip from `minikube ip`:
        - `192.168.*.* chaos-mesh-dashboards-metrics-I.local`, where `I` symbol is a number of your i cluster.
2. On base cluster:
    1. Make sure that you have a copy of `K8s-yaml-files/secret-kubeconfig.yaml` from external cluster.
    2. Set cluster name at [file](../../K8s-yaml-files/remote-cluster.yaml) config as `chaos-mesh.kubeconfig-I`.
    2. Set secret name at [file](../../K8s-yaml-files/secret-kubeconfig.yaml) config as `chaos-mesh.kubeconfig-I`.
    3. Add your new clusters vars like we did it with second cluster at [file](../common/monitoring/prometheus.yaml).
    4. Add values from external cluster such as `chaos-mesh-dashboards-metrics-2.local`, `chaos-mesh-controller-metrics-2.local` and `chaos-mesh-2.local` to to `/etc/hosts` with ip of external cluster:
        - `*.*.*.* chaos-mesh-dashboards-metrics-2.local`
    5. Run `setup/common/enable_new_external_cluster.sh`

# Install three or more clusters
Repeat 5 steps described in priveous section.
