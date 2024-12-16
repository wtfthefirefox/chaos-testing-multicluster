kubectl apply -f K8s-yaml-files/secret-kubeconfig.yaml
kubectl apply -f K8s-yaml-files/remote-cluster.yaml

helm install -f setup/common/monitoring/prometheus.yaml prometheus prometheus-community/prometheus -n monitoring --create-namespace
