# Scaling up our chaos
This instruction will describe a way to scaling up your chaos on two or more clusters

# Steps to install:
1. On new external cluster `clusterId`:
    1. Run `setup/common/setup_external_cluster.sh` script.
    2. Copy value of `K8s-yaml-files/secret-kubeconfig.yaml` to base cluster folder.
    3. Add some records with an ip equal to `minikube ip` and it would be like `192.168.*.*`:
        ```
        192.168.*.* chaos-mesh-dashboards-metrics-clusterId.local
        192.168.*.* chaos-mesh-controller-metrics-clusterId.local
        192.168.*.* chaos-mesh-clusterId.local
        ```
2. On base cluster:
    1. Make sure that you have a copy of `K8s-yaml-files/secret-kubeconfig.yaml` from external cluster.
    2. Set cluster name at [file](../../K8s-yaml-files/remote-cluster.yaml) config as `chaos-mesh.kubeconfig-clusterId`.
    2. Set secret name at [file](../../K8s-yaml-files/secret-kubeconfig.yaml) config as `chaos-mesh.kubeconfig-clusterId`.
    3. Add your new clusters vars like we did it with second cluster at [file](../common/monitoring/prometheus.yaml).
    3. Add records from an external cluster to `etc/hosts` with an ip from new cluster:
        ```
        *.*.*.* chaos-mesh-dashboards-metrics-clusterId.local
        *.*.*.* chaos-mesh-controller-metrics-clusterId.local
        *.*.*.* chaos-mesh-clusterId.local
        ```
    5. Run `setup/common/enable_new_external_cluster.sh`

# Install three or more clusters
Repeat 5 steps described in priveous section.
